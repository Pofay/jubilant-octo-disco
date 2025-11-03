defmodule ThinkLikeAProgrammerExercises.Chapter2.LuhnChecksumValidator do
  def run do
    case IO.gets("Enter a number: ") do
      "\n" ->
        IO.puts("No input (EOF).")
        :error

      line ->
        valid_checksum =
          line
          |> String.trim()
          |> validate()

        IO.puts("Is Checksum valid?: #{valid_checksum}")
        :ok
    end
  end

  def multiply_or_sum(digit) when digit * 2 < 10 do
    digit * 2
  end

  def multiply_or_sum(digit) when digit * 2 >= 10 do
    1 + rem(digit * 2, 10)
  end

  def validate(checksum) do
    if even_length?(checksum) do
      validate_even(checksum)
    else
      validate_odd(checksum)
    end
  end

  defp even_length?(checksum) do
    String.split(checksum, "", trim: true)
    |> length()
    |> rem(2) == 0
  end

  defp validate_even(checksum) do
    total =
      String.split(checksum, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({0, 1}, fn digit, {acc, pos} ->
        case pos do
          pos when rem(pos, 2) != 0 ->
            {acc + multiply_or_sum(digit), pos + 1}

          _ ->
            {acc + digit, pos + 1}
        end
      end)
      |> elem(0)

    rem(total, 10) == 0
  end

  defp validate_odd(checksum) do
    total =
      String.split(checksum, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({0, 1}, fn digit, {acc, pos} ->
        case pos do
          pos when rem(pos, 2) == 0 ->
            {acc + multiply_or_sum(digit), pos + 1}

          _ ->
            {acc + digit, pos + 1}
        end
      end)
      |> elem(0)

    rem(total, 10) == 0
  end
end
