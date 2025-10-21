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

  test "Should give empty string when creating hashtag line of 0" do
    expected = ""

    actual = HalfSquare.create_hashtag_lines(0)

    assert actual == expected
  end

  test "Should give 2 lines of hashtags ending with a newline" do
    expected = "#####\n#####\n"

    actual = HalfSquare.create_hashtag_lines(2)

    assert actual == expected
  end
end
