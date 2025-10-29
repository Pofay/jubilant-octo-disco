defmodule ThinkLikeAProgrammerExercises.Chapter2.LuhnChecksumValidator do
  def multiply_or_sum(value) when value * 2 < 10 do
    value * 2
  end

  def multiply_or_sum(value) when value * 2 >= 10 do
    1 + rem(value * 2, 10)
  end

  def validate(value) do
    total =
      String.split(value, "", trim: true)
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
end
