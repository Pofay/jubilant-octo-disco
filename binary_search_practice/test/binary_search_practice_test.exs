defmodule BinarySearchPracticeTest do
  alias BinarySearchPractice.{PerfectSquare, StandardBinarySearch}
  use ExUnit.Case

  test "is_perfect_square/1 happy paths" do
    assert PerfectSquare.is_perfect_square(0) == true
    assert PerfectSquare.is_perfect_square(1) == true
    assert PerfectSquare.is_perfect_square(4) == true
    assert PerfectSquare.is_perfect_square(49) == true
  end

  test "is_perfect_square/1 sad paths" do
    assert PerfectSquare.is_perfect_square(-1) == false
    assert PerfectSquare.is_perfect_square(2) == false
    assert PerfectSquare.is_perfect_square(3) == false
    assert PerfectSquare.is_perfect_square(5) == false
  end

  test "is_perfect_square/1 edge cases" do
    assert PerfectSquare.is_perfect_square(8) == false
    assert PerfectSquare.is_perfect_square(16) == true
    assert PerfectSquare.is_perfect_square(25) == true
    assert PerfectSquare.is_perfect_square(26) == false
  end

  test "vanilla binary search happy path" do
    assert StandardBinarySearch.binary_search([1,2,3,4,5], 1) == 0
  end

  test "vanilla binary search sad path" do
    assert StandardBinarySearch.binary_search([1,2,3,4,5], 6) == -1
  end

  test "vanilla binary search empty list" do
    assert StandardBinarySearch.binary_search([], 1) == -1
  end
end
