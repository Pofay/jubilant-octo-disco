defmodule BinarySearchPractice.FindTrueInSortedBooleanList do
  def find_boundary(list) do
    do_binary_search(0, length(list) - 1, -1, list)
  end

  defp do_binary_search(left, right, boundary_index, _list) when left > right do
    boundary_index
  end

  defp do_binary_search(left, right, boundary_index, list) do
    mid = left + div(right - left, 2)

    cond do
      Enum.at(list, mid) == true -> do_binary_search(left, mid - 1, mid, list)
      Enum.at(list, mid) == false -> do_binary_search(mid + 1, right, boundary_index, list)
    end
  end
end
