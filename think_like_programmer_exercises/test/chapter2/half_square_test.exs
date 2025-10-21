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

  test "Should start with 5 and then decrease to 4 hashtag lines if given 2" do
    expected = "#####\n####\n"

    actual = HalfSquare.create_hashtag_lines(2)

    assert actual == expected
  end

  test "Should create half a square if its given 5 lines" do
    expected = "#####\n####\n###\n##\n#\n"

    actual = HalfSquare.create_hashtag_lines(5)


    IO.puts(expected)

    assert actual == expected
  end
end
