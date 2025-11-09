defmodule ThinkLikeAProgrammerExercises.Chapter2.MessageDecoder do
  # Slightly different as I don't need a escape character to stop receiving input
  # The book needs to have -1 entered at the last to decode the input message and
  # end the program.
  def run() do
    case IO.gets("Enter numbers: ") do
      "\n" ->
        IO.puts("No input (EOF).")
        :error

      encoded_message ->
        decoded_message =
          encoded_message
          |> String.trim()
          |> decode_message()

        IO.puts("Encoded message: #{encoded_message}")
        IO.puts("Decoded message: #{decoded_message}")
        :ok
    end
  end

  def decode_message(encoded_message) do
    encoded_message
    |> String.split([",", " "], trim: true)
    |> Enum.reduce({[], "U"}, fn encoded_value, {decoded_message, decode_mode} ->
      decoded_value =
        case decode_mode do
          "U" ->
            decode_to_uppercase(encoded_value)

          "L" ->
            decode_to_lowercase(encoded_value)

          "P" ->
            decode_to_punctuation(encoded_value)
        end

      new_mode = get_decoding_mode(String.to_integer(encoded_value), decode_mode)

      {decoded_message ++ [decoded_value], new_mode}
    end)
    |> elem(0)
    |> Enum.filter(fn x -> x != 0 end)
    |> List.to_string()
  end

  defp get_decoding_mode(value, "U") when rem(value, 27) == 0 do
    "L"
  end

  defp get_decoding_mode(_value, "U") do
    "U"
  end

  defp get_decoding_mode(value, "L") when rem(value, 27) == 0 do
    "P"
  end

  defp get_decoding_mode(_value, "L") do
    "L"
  end

  defp get_decoding_mode(value, "P") when rem(value, 9) == 0 do
    "U"
  end

  defp get_decoding_mode(_value, "P") do
    "P"
  end

  def decode_to_uppercase(encoded_value) do
    encoded_value
    |> String.to_integer()
    |> to_codepoint_upper()
  end

  defp to_codepoint_upper(encoded_value) when rem(encoded_value, 27) == 0 do
    0
  end

  defp to_codepoint_upper(encoded_value) do
    rem(encoded_value, 27) + 64
  end

  def decode_to_lowercase(encoded_value) do
    encoded_value
    |> String.to_integer()
    |> to_codepoint_lowercase()
  end

  defp to_codepoint_lowercase(encoded_value) when rem(encoded_value, 27) == 0 do
    0
  end

  defp to_codepoint_lowercase(encoded_value) do
    rem(encoded_value, 27) + 96
  end

  def decode_to_punctuation(encoded_value) do
    encoded_value
    |> String.to_integer()
    |> to_codepoint_punctuation()
  end

  defp to_codepoint_punctuation(encoded_value) when rem(encoded_value, 9) == 0 do
    0
  end

  defp to_codepoint_punctuation(encoded_value) do
    codepoint = rem(encoded_value, 9)

    case codepoint do
      # !
      1 -> 33
      # ?
      2 -> 63
      # ,
      3 -> 44
      # .
      4 -> 46
      # Space
      5 -> 32
      # ;
      6 -> 59
      # "
      7 -> 34
      # '
      8 -> 39
    end
  end
end
