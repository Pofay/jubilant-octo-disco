defmodule ThinkLikeAProogrammerExercises.Chapter2.Messagedecode_to_uppercaserTest do
  use ExUnit.Case, async: true

  test "Problem Reduction: Deal with Uppercase Mode" do
    # Example
    # "143, 240"
    #  |> String.split([","," "], trim: true)
    #  |> Enum.map(&String.to_integer/1)
    #  |> Enum.map(fn a -> rem(a, 27) end)
    #  |> Enum.map(fn a -> a + 64 end)
    #  |> List.to_string
    # "HX"
    expected = "HX"

    actual = Enum.map(["143", "240", "27"], &decode_to_uppercase/1) |> List.to_string()

    assert actual == expected
  end

  test "Problem Reduction: Deal with Lowercase Mode" do
    expected = "hx"

    actual = Enum.map(["143", "240", "27"], &decode_to_lowercase/1) |> List.to_string()

    assert actual == expected
  end

  test "Problem Reduction: Deal with Punctuation Mode" do
    expected = "!' "

    actual = Enum.map(["37", "53", "50"], &decode_to_punctuation/1) |> List.to_string()

    assert actual == expected
    assert decode_to_punctuation("18") == ""
  end

  test "Actual Decoding Going on" do
    expected = "HXhy!' B"

    actual = decode_message("143, 240, 270, 143, 241, 270, 37, 53, 50, 270, 2")

    assert actual == expected
  end

  test "From the Book" do
    expected = "Right? Yes!"
    # R        i   g    h    t        ?  " "
    actual = decode_message("18,12312,171,763,98423,1208,216,11,500,18,241,0,32,20620,27,10")

    assert actual == expected
  end

  def decode_message(numeric_message) do
    numeric_message
    |> String.split([",", " "], trim: true)
    |> Enum.reduce({[], "U"}, fn numeric_value, {decoded_message, decode_mode} ->
      actual_decode_mode = get_decoding_mode(String.to_integer(numeric_value), decode_mode)

      # I think its bettter to return a {"", decoding_mode} when performing the decode
      # Since we immediately change modes before we process rather than after.
      {decoded_value, decode_mode} =
        case actual_decode_mode do
          "U" ->
            {decode_to_uppercase(numeric_value), actual_decode_mode}

          "L" ->
            {decode_to_lowercase(numeric_value), actual_decode_mode}

          "P" ->
            {decode_to_punctuation(numeric_value), actual_decode_mode}
        end

      IO.inspect("#{decode_mode} - #{numeric_value} - #{decoded_value}")

      {decoded_message ++ [decoded_value], decode_mode}
    end)
    |> elem(0)
    |> List.to_string()
  end

  defp get_decoding_mode(value, "U") do
    if rem(value, 27) == 0 do
      "L"
    else
      "U"
    end
  end

  defp get_decoding_mode(value, "L") do
    if rem(value, 27) == 0 do
      "P"
    else
      "L"
    end
  end

  defp get_decoding_mode(value, "P") do
    if rem(value, 9) == 0 do
      "U"
    else
      "P"
    end
  end

  defp decode_to_uppercase(numeric_value) do
    numeric_value
    |> String.to_integer()
    |> to_codepoint_upper()
  end

  defp to_codepoint_upper(numeric_value) do
    if rem(numeric_value, 27) == 0 do
      ""
    else
      rem(numeric_value, 27) + 64
    end
  end

  defp decode_to_lowercase(numeric_value) do
    numeric_value
    |> String.to_integer()
    |> to_codepoint_lowercase()
  end

  defp to_codepoint_lowercase(numeric_value) do
    if rem(numeric_value, 27) == 0 do
      ""
    else
      rem(numeric_value, 27) + 96
    end
  end

  defp decode_to_punctuation(numeric_value) do
    numeric_value
    |> String.to_integer()
    |> to_codepoint_punctuation()
  end

  defp to_codepoint_punctuation(numeric_value) do
    if rem(numeric_value, 9) == 0 do
      ""
    else
      codepoint = rem(numeric_value, 9)

      case codepoint do
        1 -> "!"
        2 -> "?"
        3 -> ","
        4 -> "."
        5 -> " "
        6 -> ";"
        7 -> "\""
        8 -> "\'"
      end
    end
  end
end
