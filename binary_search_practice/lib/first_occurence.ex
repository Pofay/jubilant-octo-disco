defmodule BinarySearchPractice.FirstOccurence do

  def find_first_occurence(list, target) do
    binary_search(0, length(list) - 1, -1, list, target)
  end

  defp binary_search(left, right, target_index, _list, _target) when left > right do
    target_index
  end

  defp binary_search(left, right, target_index, list, target) do
    mid = left + div(right - left, 2)

    cond do
      Enum.at(list, mid) === target -> binary_search(left, mid - 1, mid, list, target)
      Enum.at(list, mid) < target -> binary_search(mid + 1, right, target_index, list, target)
      true -> binary_search(left, mid - 1, target_index, list, target)
    end
  end
end
