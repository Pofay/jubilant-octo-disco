defmodule BinarySearchPractice.FindFeasibleValue do
  def find_first_true(list) do
    do_binary_search(0, length(list) - 1, -1, fn value -> value == true end, list)
  end

  defp do_binary_search(left, right, feasible_index, _feasible_function, _list)
       when left > right do
    feasible_index
  end

  defp do_binary_search(left, right, feasible_index, feasible_function, list) do
    mid = left + div(right - left, 2)

    cond do
      feasible_function.(Enum.at(list, mid)) ->
        do_binary_search(left, mid - 1, mid, feasible_function, list)

      not feasible_function.(Enum.at(list, mid)) ->
        do_binary_search(mid + 1, right, feasible_index, feasible_function, list)
    end
  end
end
