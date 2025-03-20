defmodule SnifflingBot do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [SnifflingBot.Consumer]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule SnifflingBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api.ApplicationCommand
  alias Nostrum.Api.Interaction
  alias SnifflingBot.Storage

  @commands [
    {"configure", "Configure the bot with the current discord user and github access token.",
     [
       %{
         name: "access_token",
         description: "The access token to use for github.",
         type: 3,
         required: true
       }
     ]},
    {"add-link", "Add a link to the gist file.",
     [
       %{
         name: "link",
         description: "The link to add to the gist file.",
         type: 3,
         required: true
       }
     ]},
    {"show-links", "Show all the links in the gist file.", []},
    {"verify", "Verify the bot is configured correctly.", []}
  ]

  def handle_event({:READY, %{guilds: guilds} = _data, _ws_state}) do
    guilds
    |> Enum.map(fn guild -> guild.id end)
    |> Enum.each(&create_guild_commands/1)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    do_command(interaction)
  end

  def create_guild_commands(guild_id) do
    Enum.each(@commands, fn {name, description, options} ->
      ApplicationCommand.create_guild_command(guild_id, %{
        name: name,
        description: description,
        options: options
      })
    end)
  end

  # I will eventually turn this discord bot into a Github App
  # and create a webserver to handle the OAuth flow.
  # To make this apparent, I'm not going to perform input validation checks on the token.
  def do_command(%{user: user, data: %{name: "configure", options: options}} = interaction) do
    [%{value: access_token} = _head | _] = options

    client = Tentacat.Client.new(%{access_token: access_token})
    gist_filename = "#{user.username}_links_archive"

    Interaction.create_response(interaction, %{type: 5})

    Task.start(fn ->
      with {:ok, _} <- verify_and_store_token(user, access_token, client),
           {:ok, gists} <- get_github_gists(client),
           {:ok, nullable_gist} <- find_gist(gists, gist_filename),
           {:ok, actual_gist} <- create_or_return_gist(client, gist_filename, nullable_gist) do
        Storage.store_gist_info(user.id, %{gist_id: actual_gist["id"], filename: gist_filename})

        Interaction.edit_response(interaction, %{
          content: "Bot configured successfully."
        })
      else
        {:error, msg} ->
          Interaction.edit_response(interaction, %{
            content: msg
          })
      end
    end)
  end

  def do_command(%{user: user, data: %{name: "add-link", options: options}} = interaction) do
    [%{value: link} = _head | _] = options

    {:msg, message} =
      with {:ok, access_token} <- Storage.get_token(user.id),
           {:ok, %{gist_id: gist_id, filename: filename}} <-
             Storage.get_gist_information(user.id) do
        client = Tentacat.Client.new(%{access_token: access_token})

        case get_github_gist(client, gist_id) do
          {:ok, gist} ->
            new_content = "#{gist["files"][filename]["content"]}\n#{link}"

            request = %{
              "files" => %{
                filename => %{"content" => new_content}
              }
            }

            case Tentacat.Gists.edit(client, gist_id, request) do
              {200, _gist, _response} -> {:msg, "Link added successfully."}
              {401, _json, _response} -> {:msg, "Access token is invalid."}
              {404, _json, _response} -> {:msg, "Gist not found."}
            end

          {:error, _} ->
            {:msg, "Gist not found."}
        end
      else
        {:error, _} -> {:msg, "Bot is not configured correctly."}
      end

    Interaction.create_response(interaction, %{
      type: 4,
      data: %{content: message}
    })
  end

  def do_command(%{user: user, data: %{name: "show-links"}} = interaction) do
    with {:ok, access_token} <- Storage.get_token(user.id),
         {:ok, %{gist_id: gist_id, filename: filename}} <-
           Storage.get_gist_information(user.id),
         {:ok, gist} <-
           get_github_gist(Tentacat.Client.new(%{access_token: access_token}), gist_id) do
      links =
        gist["files"][filename]["content"]
        |> String.split("\n", trim: true)
        |> Enum.filter(&(&1 != "// Empty"))

      if(Enum.empty?(links)) do
        Interaction.create_response(interaction, %{
          type: 4,
          data: %{content: "No links found."}
        })
      else
        Storage.store_pagination_state(user.id, links, 1)

        Interaction.create_response(interaction, %{
          type: 4,
          data: generate_paginated_message(user.id, links, 1)
        })
      end
    else
      {:error, _} ->
        Interaction.create_response(interaction, %{
          type: 4,
          data: %{content: "Bot is not configured correctly."}
        })
    end
  end

  def do_command(%{data: %{name: "verify"}} = interaction) do
    {:msg, message} =
      case Storage.get_token(interaction.user.id) do
        {:ok, _} -> {:msg, "Bot is configured correctly."}
        {:error, _} -> {:msg, "Bot is not configured correctly."}
      end

    Interaction.create_response(interaction, %{
      type: 4,
      data: %{content: message}
    })
  end

  def do_command(%{data: %{custom_id: custom_id}} = interaction) do
    [action, user_id_as_string] = String.split(custom_id, ":")
    user_id = String.to_integer(user_id_as_string)

    with {:ok, paginationState} <- Storage.get_pagination_state(user_id) do
      links = elem(paginationState, 0)
      pageNumber = elem(paginationState, 1)

      case action do
        "prev_page" ->
          new_pageNumber = max(1, pageNumber - 1)
          Storage.update_pagination_state(user_id, links, new_pageNumber)

          Interaction.create_response(interaction, %{
            type: 4,
            data: generate_paginated_message(user_id, links, new_pageNumber)
          })

        "next_page" ->
          new_pageNumber = max(1, pageNumber + 1)
          Storage.update_pagination_state(user_id, links, new_pageNumber)

          Interaction.create_response(interaction, %{
            type: 4,
            data: generate_paginated_message(user_id, links, new_pageNumber)
          })
      end
    else
      {:error, message} ->
        Interaction.create_response(interaction, %{
          type: 4,
          data: %{content: message}
        })
    end
  end

  def get_github_user(client) do
    case Tentacat.Users.me(client) do
      {200, %{"login" => login}, _response} -> {:ok, login}
      {401, _json, _response} -> {:error, "Access token is invalid."}
    end
  end

  def get_github_gists(client) do
    case Tentacat.Gists.list_mine(client) do
      {200, gists, _response} -> {:ok, gists}
      {401, _json, _response} -> {:error, "Access token is invalid."}
    end
  end

  def get_github_gist(client, gist_id) do
    case Tentacat.Gists.gist_get(client, gist_id) do
      {200, gist, _response} -> {:ok, gist}
      {404, _json, _response} -> {:error, "Gist not found."}
    end
  end

  def create_gist(client, gist_filename) do
    request = %{
      "files" => %{
        gist_filename => %{"content" => "// Empty"}
      },
      "description" => gist_filename,
      "public" => false
    }

    case Tentacat.Gists.create(client, request) do
      {201, gist, _response} -> {:ok, gist}
      {401, _json, _response} -> {:error, "Access token is invalid."}
    end
  end

  defp generate_paginated_message(user_id, links, pageNumber) do
    page_size = 5
    total_pages = ceil(length(links) / page_size)
    start_index = (pageNumber - 1) * page_size
    paginated_links = Enum.slice(links, start_index, page_size) |> Enum.join("\n")

    %{
      content: "**Links (Page #{pageNumber}/#{total_pages}):**\n#{paginated_links}",
      components: [
        %{
          type: 1,
          components: [
            %{
              type: 2,
              style: 2,
              custom_id: "prev_page:#{user_id}",
              label: "⬅ Previous",
              disabled: pageNumber == 1
            },
            %{
              type: 2,
              style: 2,
              custom_id: "next_page:#{user_id}",
              label: "Next ➡",
              disabled: pageNumber == total_pages
            }
          ]
        }
      ]
    }
  end

  defp verify_and_store_token(user, access_token, client) do
    with {:ok, _} <- get_github_user(client) do
      Storage.store_token(user.id, access_token)
      {:ok, "Bot configured successfully."}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  defp create_or_return_gist(client, gist_filename, nil) do
    case create_gist(client, gist_filename) do
      {:ok, gist} -> {:ok, gist}
      {:error, _} -> {:error, "Something went wrong."}
    end
  end

  defp create_or_return_gist(_client, _gist_filename, gist) do
    {:ok, gist}
  end

  def find_gist(gists, gist_filename) do
    case Enum.find(gists, fn gist ->
           gist["description"] == gist_filename
         end) do
      nil -> {:ok, nil}
      gist -> {:ok, gist}
    end
  end
end
