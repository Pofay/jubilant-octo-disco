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

  def do_command(%{data: %{name: "verify"}} = interaction) do
    case Storage.get_token(interaction.user.id) do
      {:ok, _} -> {:msg, "Bot is configured correctly."}
      {:error, _} -> {:msg, "Bot is not configured correctly."}
    end
  end

  def do_command(%{user: user, data: %{name: "configure", options: options} = _interaction}) do
    [head | _] = options
    IO.inspect(head.value)
    Storage.store(user.id, head.value)

    {:msg, "Bot is now configured to perform REST API calls to Github."}
  end
end
