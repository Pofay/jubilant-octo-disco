defmodule ThinkLikeAProgrammerExercises.Chapter2.MessageDecoderTest do
  use ExUnit.Case, async: true

  alias ThinkLikeAProgrammerExercises.Chapter2.MessageDecoder

  test "Problem Reduction: Deal with Uppercase Mode" do
    expected = "HX"

    actual = Enum.map(["143", "240"], &MessageDecoder.decode_to_uppercase/1) |> List.to_string()

    assert actual == expected
  end

  test "Problem Reduction: Deal with Lowercase Mode" do
    expected = "hx"

    actual = Enum.map(["143", "240"], &MessageDecoder.decode_to_lowercase/1) |> List.to_string()

    assert actual == expected
  end

  test "Problem Reduction: Upper and Lower case modes return 0 when decoding a value divisible by 27" do
    assert MessageDecoder.decode_to_uppercase("27") == 0
    assert MessageDecoder.decode_to_lowercase("27") == 0
  end

  test "Problem Reduction: Punctuation case mode return 0 when decoding a value divisible by 9" do
    assert MessageDecoder.decode_to_punctuation("9") == 0
  end

  test "Problem Reduction: Deal with Punctuation Mode" do
    expected = "!' "

    actual = Enum.map(["37", "53", "50"], &MessageDecoder.decode_to_punctuation/1) |> List.to_string()

    assert actual == expected
  end

  test "Actual Decoding Going on" do
    expected = "HXhy!' B"

    actual = MessageDecoder.decode_message("143, 240, 270, 143, 241, 270, 37, 53, 50, 270, 2")

    assert actual == expected
  end

  test "From the Book" do
    expected = "Right? Yes!"

    actual = MessageDecoder.decode_message("18,12312,171,763,98423,1208,216,11,500,18,241,0,32,20620,27,10")

    assert actual == expected
  end
end
