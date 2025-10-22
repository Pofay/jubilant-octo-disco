defmodule ThinkLikeAProgrammerExercises.Chapter2.HalfSquare do
  def create_hashtags(count) when count <= 0 do
    ""
  end

  def create_hashtags(count) do
    initial_state = ""

    Enum.reduce(1..count, initial_state, fn _i, acc ->
      acc <> "#"
    end)
  end

  def create_decreasing_hashtag_lines(lines) when lines <= 0 do
    ""
  end

  def create_decreasing_hashtag_lines(lines) do
    hashtag_lines = ""

    Enum.reduce(1..lines, hashtag_lines, fn i, acc ->
      new_line = create_hashtags(lines + 1 - i)
      acc <> new_line <> "\n"
    end)
  end

  def create_increasing_hashtag_lines(lines) when lines <= 0 do
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
