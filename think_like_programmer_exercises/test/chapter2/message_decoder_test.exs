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

    actual = Enum.map(["143", "240"], &decode_to_uppercase/1) |> List.to_string()

    assert actual == expected
  end

  test "Problem Reduction: Deal with Lowercase Mode" do
    expected = "hx"

    actual = Enum.map(["143", "240"], &decode_to_lowercase/1) |> List.to_string()

    assert actual == expected
  end


  defp decode_to_uppercase(numeric_value) do
    numeric_value
    |> String.to_integer()
    |> to_codepoint_upper()
  end

  defp to_codepoint_upper(numeric_value) do
    rem(numeric_value, 27) + 64
  end

  defp decode_to_lowercase(numeric_value) do
    numeric_value
    |> String.to_integer()
    |> to_codepoint_lowercase()
  end

  defp to_codepoint_lowercase(numeric_value) do
    rem(numeric_value, 27) + 96
  end


end
