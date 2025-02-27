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
  alias Tentacat.Client

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
    {"setup-gist", "Setup the bot to create the gist file for the user.",
     [
       %{
         name: "gist_filename",
         description: "The name of the gist file to create.",
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
    {"verify", "Verify the bot is configured correctly.", []}
  ]

  def handle_event({:READY, %{guilds: guilds} = _data, _ws_state}) do
    guilds
    |> Enum.map(fn guild -> guild.id end)
    |> Enum.each(&create_guild_commands/1)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    {:msg, msg} = do_command(interaction)

    Interaction.create_response(interaction, %{type: 4, data: %{content: msg}})
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

  # I woud like to find an alternative to with matching as its very verbose
  # I'd have like it to follow a Railway Oriented Programming pattern
  def do_command(%{user: user, data: %{name: "setup-gist", options: options} = _interaction}) do
    [%{value: gist_filename} = _head | _] = options

    case Storage.get_token(user.id) do
      {:ok, access_token} ->
        client = Tentacat.Client.new(%{access_token: access_token})

        # This GET request may cause the bot to lag, especially if the user has a lot of gists.
        # I will migrate to the GraphQL API later to make this more efficient.
        with {:ok, gists} <- get_github_gists(client) do
          case find_gist(gists, gist_filename) do
            nil ->
              with {:ok, gist} <- create_gist(client, gist_filename) do
                Storage.store_gist_info(user.id, %{gist_id: gist["id"], filename: gist_filename})
                {:msg, "Gist setup successfully."}
              else
                {:error, _} -> {:msg, "Something went wrong."}
              end

            existingGist ->
              Storage.store_gist_info(user.id, %{
                gist_id: existingGist["id"],
                filename: gist_filename
              })

              {:msg, "Gist setup successfully."}
          end
        else
          {:error, _} -> {:msg, "Something went wrong."}
        end

      {:error, _} ->
        {:msg, "Token does not exist. Please configure the bot first."}
    end
  end

  # I will eventually turn this discord bot into a Github App
  # and create a webserver to handle the OAuth flow.
  # To make this apparent, I'm not going to perform input validation checks on the token.
  def do_command(%{user: user, data: %{name: "configure", options: options} = _interaction}) do
    [%{value: access_token} = _head | _] = options

    client = Tentacat.Client.new(%{access_token: access_token})

    with {:ok, _} <- get_github_user(client) do
      Storage.store_token(user.id, access_token)
      {:msg, "Bot configured successfully."}
    else
      {:error, msg} -> {:msg, msg}
    end
  end

  def do_command(%{user: user, data: %{name: "add-link", options: options} = _interaction}) do
    [%{value: link} = _head | _] = options

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
  end

  def do_command(%{data: %{name: "verify"}} = interaction) do
    case Storage.get_token(interaction.user.id) do
      {:ok, _} -> {:msg, "Bot is configured correctly."}
      {:error, _} -> {:msg, "Bot is not configured correctly."}
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

  def find_gist(gists, gist_filename) do
    Enum.find(gists, fn gist ->
      gist["description"] == gist_filename
    end)
  end
end
