defmodule ThinkLikeAProgrammerExercises.Chapter5.ClassRoster do
  alias ThinkLikeAProgrammerExercises.Chapter5.Student

  def add_record(%{id: id, name: name, grade: grade}, students) do
    updated_students = [create_student(id, name, grade) | students]
    Enum.sort(updated_students, &(&1.grade >= &2.grade))
  end

  defp create_student(id, name, grade) do
    %Student{id: id, name: name, grade: grade, grade_letter: get_letter_grade(grade)}
  end

  def remove_record(id, roster) do
    Enum.filter(roster, fn student -> student.id != id end)
  end

  def get_record(_, []) do
    {:error, "roster is empty."}
  end

  def get_record(id, roster) do
    case Enum.find(roster, fn student -> student.id == id end) do
      nil -> {:error, "record does not exist."}
      student -> {:ok, student}
    end
  end

  def get_letter_grade(grade) when 0 >= grade or grade <= 100 do
    grade_letters = ["F", "D", "D+", "C-", "C", "C+", "B-", "B", "B+", "A-", "A"]

    lowest_grade_scores = [0, 60, 67, 70, 73, 77, 80, 83, 87, 90, 93]

    category_index =
      Enum.reduce(lowest_grade_scores, 0, fn grade_score, current_category ->
        if grade_score <= grade do
          current_category + 1
        else
          current_category
        end
      end)

    Enum.fetch!(grade_letters, category_index - 1)
  end
end
