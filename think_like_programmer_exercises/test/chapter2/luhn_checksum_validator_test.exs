defmodule ThinkLikeAProgrammerExercises.Chapter2.LuhnChecksumValidatorTest do
  use ExUnit.Case, async: true

  alias ThinkLikeAProgrammerExercises.Chapter2.LuhnChecksumValidator

  test "Problem Reduction 1: It should double a digit" do
    expected = 4

    actual = LuhnChecksumValidator.multiply_or_sum(2)

    assert actual == expected
  end

  test "Problem Reduction 1: When a doubled digit has 2 Digits, it returns the sum of both digits" do
    expected = 1

    actual = LuhnChecksumValidator.multiply_or_sum(5)

    assert actual == expected
  end
end
