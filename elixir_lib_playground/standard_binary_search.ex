defmodule BinarySearchPractice.StandardBinarySearch do
  @moduledoc """
  Implementation from Algomonster
   public static int BinarySearch(List<int> arr, int target)
    {
        int left = 0;
        int right = arr.Count - 1;
        while (left <= right) // <= here because left and right could point to the same element, < would miss it
        {
            int mid = left + (right - left) / 2; // use `(right - left) / 2` to prevent `left + right` potential overflow
            // found target, return its index
            if (arr[mid] == target) return mid;
            if (arr[mid] < target)
            {
                // middle less than target, discard left half by making left search boundary `mid + 1`
                left = mid + 1;
            }
            else
            {
                // middle greater than target, discard right half by making right search boundary `mid - 1`
                right = mid - 1;
            }
        }
        return -1; // if we get here we didn't hit above return so we didn't find target
    }
  """
  def binary_search(list, target) do
    do_binary_search(0, length(list) - 1, list, target)
  end

  def do_binary_search(left, right, _list, _target) when left > right do
    -1
  end

  def do_binary_search(left, right, list, target) do
    mid = left + div(right - left, 2)

    cond do
      Enum.at(list, mid) == target -> mid
      Enum.at(list, mid) < target -> do_binary_search(mid + 1, right, list, target)
      Enum.at(list, mid) > target -> do_binary_search(left, mid - 1, list, target)
    end
  end
end
