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

  alias Nostrum.Api.Message
  alias Nostrum.Api.ApplicationCommand
  alias Nostrum.Api.Interaction
  alias Nostrum.Snowflake

  @commands [
    {"configure", "Configure the bot with the current discord user and github access token.",
     [
       %{
         name: "access_token",
         description: "The access token to use for github.",
         type: 3,
         required: true
       }
     ]}
  ]

  def handle_event({:READY, %{guilds: guilds} = _data, _ws_state}) do
    guilds
    |> Enum.map(fn guild -> guild.id end)
    |> Enum.each(&create_guild_commands/1)
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

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    message =
      case do_command(interaction) do
        {:msg, msg} -> msg
        _ -> ":white_check_mark:"
      end

    Interaction.create_response(interaction, %{type: 4, data: %{content: message}})
  end

  def do_command(%{user: user, data: %{options: options} = interaction}) do
    IO.inspect(interaction)
    IO.inspect(user)
    IO.inspect(options)
    {:msg, "Test configuration"}
  end
end
