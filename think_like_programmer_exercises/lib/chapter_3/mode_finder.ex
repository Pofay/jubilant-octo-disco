defmodule ThinkLikeAProgrammerExercises.Chapter3.ModeFinder do
  def get_frequency_and_mode(survey_data) do
    Enum.reduce(survey_data, List.duplicate(0, length(survey_data)), fn questionnaire_index,
                                                                          histogram ->
      case questionnaire_index do
        0 ->
          histogram

        _ ->
          frequency = Enum.fetch!(histogram, questionnaire_index - 1)
          List.replace_at(histogram, questionnaire_index - 1, frequency + 1)
      end
    end)
    |> Enum.with_index(1)
    |> Enum.max_by(fn {frequency, _possible_mode} -> frequency end)
    |> (fn {frequency, mode} -> %{frequency: frequency, mode: mode} end).()
  end
end
