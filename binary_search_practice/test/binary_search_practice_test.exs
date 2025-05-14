defmodule BinarySearchPracticeTest do
  alias BinarySearchPractice.PerfectSquare
  use ExUnit.Case

  test "is_perfect_square/1 happy paths" do
    assert PerfectSquare.is_perfect_square(0) == true
    assert PerfectSquare.is_perfect_square(1) == true
    assert PerfectSquare.is_perfect_square(4) == true
    assert PerfectSquare.is_perfect_square(49) == true
    assert PerfectSquare.is_perfect_square(50) == false
  end
end
