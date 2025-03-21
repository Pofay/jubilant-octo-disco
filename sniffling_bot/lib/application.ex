defmodule SnifflingBot.Application do
  use Application

  def start(_type, _args) do
    SnifflingBot.Storage.init()

    children = [
      SnifflingBot
    ]

    opts = [strategy: :one_for_one, name: SnifflingBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
