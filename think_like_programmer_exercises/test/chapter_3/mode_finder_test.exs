defmodule ThinkLikeAProgrammerExercises.Chapter2.ModeFinderTest do
  use ExUnit.Case, async: true

  test "Problem Reduction: Checking how replace_at/3 works" do
    list = [0, 0, 0]
    expected = [0, 2, 0]

    actual = List.replace_at(list, 1, 2)

    assert actual == expected
  end

  test "Problem Reduction: Using reduce to create a list that counts occurences" do
    survey_question_numbers = [4, 4, 1, 2, 4, 5]
    survey_occurences = [0, 0, 0, 0, 0]
    expected = [1, 1, 0, 3, 1]

    # Count the occurences by index
    updated_occurences =
      Enum.reduce(survey_question_numbers, survey_occurences, fn v, occurences ->
        case v do
          0 ->
            occurences

          _ ->
            occurence = Enum.fetch!(occurences, v - 1)
            List.replace_at(occurences, v - 1, occurence + 1)
        end
      end)

    # Find the index with the highest occurences

    assert updated_occurences == expected
  end
end
