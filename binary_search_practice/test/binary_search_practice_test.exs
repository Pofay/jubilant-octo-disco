defmodule BinarySearchPracticeTest do
  alias BinarySearchPractice.{PerfectSquare, StandardBinarySearch}
  use ExUnit.Case

  test "is_perfect_square/1 happy paths" do
    assert PerfectSquare.is_perfect_square(0) == true
    assert PerfectSquare.is_perfect_square(1) == true
    assert PerfectSquare.is_perfect_square(4) == true
    assert PerfectSquare.is_perfect_square(49) == true
    assert PerfectSquare.is_perfect_square(50) == false
  end

  test "vanilla binary search happy path" do
    assert StandardBinarySearch.binary_search([1,2,3,4,5], 1) == 0
  end

  test "vanilla binary search sad path" do
    assert StandardBinarySearch.binary_search([1,2,3,4,5], 6) == -1
  end
end
