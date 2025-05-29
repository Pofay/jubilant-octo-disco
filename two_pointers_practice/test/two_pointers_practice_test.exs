defmodule TwoPointersPracticeTest do
  use ExUnit.Case

  alias TwoPointersPractice.{
    RemoveDuplicates,
    MiddleOfList
  }

  test "remove duplicates" do
    assert RemoveDuplicates.remove_duplicates([]) === []
    assert RemoveDuplicates.remove_duplicates([1, 1, 2, 2, 2, 3, 4, 4]) === [1, 2, 3, 4]
    assert RemoveDuplicates.remove_duplicates([0, 0, 0, 0, 1, 2, 2]) === [0, 1, 2]
  end

  test "middle of a list" do
    assert MiddleOfList.find_middle([1]) === 1
    assert MiddleOfList.find_middle([3, 4]) === 4
    assert MiddleOfList.find_middle([0, 1, 2, 3, 4]) === 2
    assert MiddleOfList.find_middle([0, 1, 2, 3, 4, 5]) === 3
  end
end
