defmodule ThinkLikeAProgrammerExercises.Chapter2.HalfSquareTest do
  use ExUnit.Case, async: true

  alias ThinkLikeAProgrammerExercises.Chapter2.HalfSquare

  test "Should give empty string when given 0" do
    expected = ""

    actual = HalfSquare.create_hashtags(0)

    assert actual == expected
  end

  test "Should give 1 hashtag" do
    expected = "#"

    actual = HalfSquare.create_hashtags(1)

    assert actual == expected

  end

  test "Should give 5 hashtags" do
    expected = "#####"

    actual = HalfSquare.create_hashtags(5)

    assert actual == expected
  end
end
