defmodule BinarySearchPractice.MinimumInRotatedSortedArray do
  def find_minimum_value(list) do
    do_boundary_binary_search(0, length(list) - 1, -1, list)
  end

  defp do_boundary_binary_search(left, right, boundary_index, _list) when left > right do
    boundary_index
  end

  defp do_boundary_binary_search(left, right, boundary_index, list) do
    mid = left + div(right - left, 2)

    cond do
      Enum.at(list, mid) <= Enum.at(list, length(list) - 1) ->
        do_boundary_binary_search(left, mid - 1, mid, list)

      true ->
        do_boundary_binary_search(mid + 1, right, boundary_index, list)
    end
  end
end
