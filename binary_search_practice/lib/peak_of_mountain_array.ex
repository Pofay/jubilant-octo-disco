defmodule BinarySearchPractice.PeakOfMountainArray do
  def find_peak(list) do
    binary_search(0, length(list) - 1, -1, list)
  end

  defp binary_search(left, right, boundary_index, _list) when left > right do
    boundary_index
  end

  defp binary_search(left, right, boundary_index, list) do
    mid = left + div(right - left, 2)

    cond do
      Enum.at(list, mid) > Enum.at(list, mid + 1) ->
        binary_search(left, mid - 1, mid, list)
      true -> binary_search(mid + 1, right, boundary_index, list)
    end
  end
end
