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
end
