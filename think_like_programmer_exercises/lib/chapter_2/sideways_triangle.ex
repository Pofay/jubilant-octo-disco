defmodule ThinkLikeAProgrammerExercises.Chapter2.SidewaysTriangle do
  alias ThinkLikeAProgrammerExercises.Chapter2.HalfSquare

  def create_sideways_triangle(base_length) when base_length <= 0 do
    ""
  end

  def create_sideways_triangle(base_length) do
    state = ""
    actual_length = base_length * 2 - 1

    Enum.reduce(1..actual_length, state, fn i, acc ->
      case i do
        i when i <= base_length ->
          line = HalfSquare.create_hashtags(i)
          acc <> line <> "\n"

        _ ->
          line = HalfSquare.create_hashtags(base_length - (i - base_length))
          acc <> line <> "\n"
      end
    end)
  end
end
