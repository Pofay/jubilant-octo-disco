defmodule ThinkLikeAProgrammerExercises.Chapter2.HalfSquare do

  def create_hashtags(0) do
    ""
  end

  def create_hashtags(hashtag_quantity) do
    initial_state = ""
    Enum.reduce(1..hashtag_quantity, initial_state, fn _i, acc ->
      acc <> "#"
    end)
  end

  def create_hashtag_lines(0) do
    ""
  end

  def create_hashtag_lines(lines) do
    hashtag_lines = ""
    Enum.reduce(1..lines, hashtag_lines, fn i, acc ->
      new_line = create_hashtags(6 - i)
      acc <> new_line <> "\n"
    end)
  end
end
