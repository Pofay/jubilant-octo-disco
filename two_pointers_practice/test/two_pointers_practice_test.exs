defmodule TwoPointersPracticeTest do
  use ExUnit.Case
  alias TwoPointersPractice.RemoveDuplicates

  test "remove duplicates" do
    assert RemoveDuplicates.remove_duplicates([]) === []
    assert RemoveDuplicates.remove_duplicates([1, 1, 2, 2, 2, 3, 4, 4]) === [1, 2, 3, 4]
    assert RemoveDuplicates.remove_duplicates([0, 0, 0, 0, 1, 2, 2]) === [0, 1, 2]
  end
end
