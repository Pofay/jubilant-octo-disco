defmodule BinarySearchPractice.FirstElementLargerOrEqualToTarget do
  def find_target(list, target) do
    do_binary_search(
      0,
      length(list) - 1,
      -1,
      fn list, index, target -> Enum.at(list, index) >= target end,
      list,
      target
    )
  end

  defp do_binary_search(left, right, boundary_index, _feasible_function, _list, _target)
       when left > right do
    boundary_index
  end

  defp do_binary_search(left, right, boundary_index, feasible_function, list, target) do
    # Use div to make sure its gonna return an integer
    # left + (right - left) / 2 -> will return a floating point
    # which causes Enum.at/3 to fail due to its when is_integer(index) guard
    mid = left + div((right - left), 2)

    cond do
      feasible_function.(list, mid, target) ->
        do_binary_search(left, mid - 1, mid, feasible_function, list, target)

      true ->
        do_binary_search(mid + 1, right, boundary_index, feasible_function, list, target)
    end
  end
end
