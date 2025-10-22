defmodule ThinkLikeAProgrammerExercises.Chapter2.HalfSquare do

  def create_hashtags(0) do
    ""
  end

  def create_hashtags(count) do
    initial_state = ""
    Enum.reduce(1..count, initial_state, fn _i, acc ->
      acc <> "#"
    end)
  end

  def create_decreasing_hashtag_lines(0) do
    ""
  end

  def create_decreasing_hashtag_lines(lines) do
    hashtag_lines = ""
    Enum.reduce(1..lines, hashtag_lines, fn i, acc ->
      new_line = create_hashtags(6 - i)
      acc <> new_line <> "\n"
    end)
  end

  @spec create_increasing_hashtag_lines(any()) :: nil | <<>>
  def create_increasing_hashtag_lines(0) do
    ""
  end

  def create_increasing_hashtag_lines(lines) do
    hashtag_lines = ""
    Enum.reduce(1..lines, hashtag_lines, fn i, acc ->
      new_line = create_hashtags(i)
      acc <> new_line <> "\n"
    end)

  end
end
