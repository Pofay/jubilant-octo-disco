defmodule SnifflingBotTest do
  use ExUnit.Case
  doctest SnifflingBot

  test "greets the world" do
    assert SnifflingBot.hello() == :world
  end
end
