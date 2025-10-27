defmodule ThinkLikeAProgrammerExercises.Chapter2.LuhnChecksumValidator do
  def multiply_or_sum(value) when value * 2 < 10 do
    value * 2
  end

  def multiply_or_sum(value) when value * 2 >= 10 do
    1 + rem(value * 2, 10)
  end
end
