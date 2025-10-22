defmodule ThinkLikeAProgrammerExercises.Chapter2.SidewaysTriangleTest do
  use ExUnit.Case, async: true

  alias ThinkLikeAProgrammerExercises.Chapter2.SidewaysTriangle

  test "Should give empty string when given 0" do
    expected = ""

    actual = SidewaysTriangle.create_sideways_triangle(0)

    assert actual == expected
  end

  test "Should create a sideways triangle" do
    expected = "#\n##\n###\n####\n#####\n####\n###\n##\n#\n"

    actual = SidewaysTriangle.create_sideways_triangle(5)

    IO.puts(actual)

    assert actual == expected
  end

  test "Should create a sideways triangle with a base of 4" do
    expected = "#\n##\n###\n####\n###\n##\n#\n"

    actual = SidewaysTriangle.create_sideways_triangle(4)

    IO.puts(actual)

    assert actual == expected
  end
end
