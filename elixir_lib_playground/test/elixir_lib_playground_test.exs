defmodule ElixirLibPlaygroundTest do
  use ExUnit.Case
  doctest ElixirLibPlayground

  test "greets the world" do
    assert ElixirLibPlayground.hello() == :world
  end
end
