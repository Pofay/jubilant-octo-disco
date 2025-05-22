defmodule BinarySearchPracticeTest do
  alias BinarySearchPractice.{
    PerfectSquare,
    StandardBinarySearch,
    FindTrueInSortedBooleanList,
    FindFeasibleValue,
    FirstElementLargerOrEqualToTarget,
    FirstOccurence,
    SquareRootEstimation,
    MinimumInRotatedSortedArray
  }

  use ExUnit.Case

  test "is_perfect_square/1 happy paths" do
    assert PerfectSquare.is_perfect_square(0) == true
    assert PerfectSquare.is_perfect_square(1) == true
    assert PerfectSquare.is_perfect_square(4) == true
    assert PerfectSquare.is_perfect_square(49) == true
    assert PerfectSquare.is_perfect_square(9) == true
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
    assert StandardBinarySearch.binary_search([1, 2, 3, 4, 5], 1) == 0
  end

  test "vanilla binary search sad path" do
    assert StandardBinarySearch.binary_search([1, 2, 3, 4, 5], 6) == -1
  end

  test "vanilla binary search empty list" do
    assert StandardBinarySearch.binary_search([], 1) == -1
  end

  test "find_boundary/1 empty list should return -1" do
    assert FindTrueInSortedBooleanList.find_boundary([]) == -1
  end

  test "find_boundary/1 list with no true values should return -1" do
    assert FindTrueInSortedBooleanList.find_boundary([false, false, false]) == -1
  end

  test "find_boundary/1 should return the index of first true value" do
    assert FindTrueInSortedBooleanList.find_boundary([false, false, true]) == 2
    assert FindTrueInSortedBooleanList.find_boundary([false, true, true]) == 1
    assert FindTrueInSortedBooleanList.find_boundary([true, true, true]) == 0
  end

  test "find_boundary/1 sanity test" do
    assert FindTrueInSortedBooleanList.find_boundary([
             false,
             false,
             false,
             true,
             true,
             true,
             true
           ]) ==
             3
  end

  test "first true feasible value" do
    assert FindFeasibleValue.find_first_true([false, false, true]) == 2
    assert FindFeasibleValue.find_first_true([false, true, true]) == 1
    assert FindFeasibleValue.find_first_true([true, true, true]) == 0
    assert FindFeasibleValue.find_first_true([false, false, false]) == -1
    assert FindFeasibleValue.find_first_true([]) == -1
  end

  test "find_feasible_target/2" do
    assert FindFeasibleValue.find_feasible_target([], 1) == -1
    assert FindFeasibleValue.find_feasible_target([1, 2, 3, 4, 5], 3) == 2
    assert FindFeasibleValue.find_feasible_target([1, 3, 3, 5, 8, 8, 10], 3) === 1
  end

  test "first element larger than or equal to target" do
    assert FirstElementLargerOrEqualToTarget.find_target([1, 3, 3, 5, 8, 8, 10], 3) === 1
  end

  test "first occurence" do
    assert FirstOccurence.find_first_occurence([], 1) === -1
    assert FirstOccurence.find_first_occurence([1, 3, 3, 3, 3, 6, 10, 10, 10, 100], 3) === 1
    assert FirstOccurence.find_first_occurence([2, 3, 5, 7, 11, 19], 20) === -1
    assert FirstOccurence.find_first_occurence([2, 3, 5, 7, 11, 13, 17, 19], 19) === 7
  end

  test "perfect square estimation" do
    assert SquareRootEstimation.estimate_square_root(0) === 0
    assert SquareRootEstimation.estimate_square_root(8) === 2
    assert SquareRootEstimation.estimate_square_root(9) === 3
    assert SquareRootEstimation.estimate_square_root(16) === 4
  end

  test "minimum in rotated sorted array" do
    assert MinimumInRotatedSortedArray.find_minimum_value([1, 2, 3, 4, 5]) === 0
    assert MinimumInRotatedSortedArray.find_minimum_value([30, 40, 50, 10, 20]) === 3
    # The page assumes its 7 but its an error.
    assert MinimumInRotatedSortedArray.find_minimum_value([3, 5, 7, 11, 17, 19, 2]) === 6
  end

  test "minimum in sorted array edge cases" do
    # Single element
    assert MinimumInRotatedSortedArray.find_minimum_value([99]) == 0

    # Two elements
    assert MinimumInRotatedSortedArray.find_minimum_value([1, 2]) == 0
    assert MinimumInRotatedSortedArray.find_minimum_value([2, 1]) == 1

    # Large jump
    assert MinimumInRotatedSortedArray.find_minimum_value([1000, 2000, 3000, 1, 2, 3]) == 3
  end
end
