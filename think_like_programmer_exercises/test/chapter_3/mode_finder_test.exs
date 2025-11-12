defmodule ThinkLikeAProgrammerExercises.Chapter2.ModeFinderTest do
  use ExUnit.Case, async: true

  alias ThinkLikeAProgrammerExercises.Chapter3.ModeFinder

  test "Problem Reduction: Checking how replace_at/3 works" do
    list = [0, 0, 0]
    expected = [0, 2, 0]

    actual = List.replace_at(list, 1, 2)

    assert actual == expected
  end

  test "Problem Reduction: Using reduce to create a list that creates histogram via list indexes" do
    survey_question_numbers = [4, 4, 1, 2, 4, 5]
    questionnaire_histogram = [0, 0, 0, 0, 0]
    expected = [1, 1, 0, 3, 1]

    # Count the histogram by index
    updated_histogram =
      Enum.reduce(survey_question_numbers, questionnaire_histogram, fn questionnaire_index,
                                                                       histogram ->
        case questionnaire_index do
          0 ->
            histogram

          _ ->
            frequency = Enum.fetch!(histogram, questionnaire_index - 1)
            List.replace_at(histogram, questionnaire_index - 1, frequency + 1)
        end
      end)

    assert updated_histogram == expected

    # Get the mode
    {frequency, mode} =
      updated_histogram
      |> Enum.with_index(1)
      |> Enum.max_by(fn {frequency, _possible_mode} -> frequency end)

    assert frequency == 3
    assert mode == 4
  end

  test "Actual Solution: Get mode and frequency" do
    survey_data = [7, 7, 7, 2, 3, 2, 10, 5, 6, 6, 7]

    expected = {4, 7}

    actual = ModeFinder.find_mode(survey_data)

    assert actual == expected
  end
end
