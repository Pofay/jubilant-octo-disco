defmodule ThinkLikeAProgrammerExercises.Chapter5.ClassRosterTest do
  use ExUnit.Case, async: true

  alias ThinkLikeAProgrammerExercises.Chapter5.Student
  alias ThinkLikeAProgrammerExercises.Chapter5.ClassRoster

  test "Problem Reduction 1: Given a Grade between 0-59, should return F" do
    assert "F" == ClassRoster.get_letter_grade(0)
    assert "F" == ClassRoster.get_letter_grade(20)
    assert "F" == ClassRoster.get_letter_grade(59)
  end

  test "Problem Reduction 1.5: Given a Grade between 60-66, should return D" do
    assert "D" == ClassRoster.get_letter_grade(60)
    assert "D" == ClassRoster.get_letter_grade(66)
  end

  test "Sanity Checks" do
    assert "D+" == ClassRoster.get_letter_grade(67)
    assert "D+" == ClassRoster.get_letter_grade(69)

    assert "C-" == ClassRoster.get_letter_grade(70)
    assert "C-" == ClassRoster.get_letter_grade(72)

    assert "C" == ClassRoster.get_letter_grade(73)
    assert "C" == ClassRoster.get_letter_grade(76)

    assert "C+" == ClassRoster.get_letter_grade(77)
    assert "C+" == ClassRoster.get_letter_grade(79)

    assert "B-" == ClassRoster.get_letter_grade(80)
    assert "B-" == ClassRoster.get_letter_grade(82)

    assert "B" == ClassRoster.get_letter_grade(83)
    assert "B" == ClassRoster.get_letter_grade(86)

    assert "B+" == ClassRoster.get_letter_grade(87)
    assert "B+" == ClassRoster.get_letter_grade(89)

    assert "A-" == ClassRoster.get_letter_grade(90)
    assert "A-" == ClassRoster.get_letter_grade(92)

    assert "A" == ClassRoster.get_letter_grade(93)
    assert "A" == ClassRoster.get_letter_grade(100)
  end

  test "Add Record" do
    expected = [%Student{id: 1, name: "Pofay", grade: 70, grade_letter: "C-"}]

    actual = ClassRoster.add_record(%{id: 1, name: "Pofay", grade: 70}, [])

    assert actual == expected
  end

  test "Remove Record" do
    roster = [
      %Student{id: 5, name: "Pofire", grade: 89, grade_letter: "B+"},
      %Student{id: 6, name: "Sprakak", grade: 81, grade_letter: "B-"}
    ]

    expected = [%Student{id: 6, name: "Sprakak", grade: 81, grade_letter: "B-"}]

    actual = ClassRoster.remove_record(5, roster)

    assert actual == expected
  end

  test "Get Record" do
    roster = [
      %Student{id: 2, name: "Milady", grade: 92, grade_letter: "A-"},
      %Student{id: 8, name: "Milord", grade: 85, grade_letter: "B"}
    ]

    expected = {:ok, %Student{id: 2, name: "Milady", grade: 92, grade_letter: "A-"}}

    actual = ClassRoster.get_record(2, roster)

    assert actual == expected
  end

  test "Get record should return :error if record not found" do
    roster = [
      %Student{id: 4, name: "Jian", grade: 92, grade_letter: "A-"},
      %Student{id: 7, name: "Jianna", grade: 93, grade_letter: "A"}
    ]

    expected = {:error, "record does not exist."}

    actual = ClassRoster.get_record(2, roster)

    assert actual == expected
  end

  test "Get record with empty list returns error with empty roster message" do
    roster = []

    expected = {:error, "roster is empty."}

    actual = ClassRoster.get_record(2, roster)

    assert actual == expected
  end
end
