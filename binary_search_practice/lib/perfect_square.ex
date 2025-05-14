defmodule BinarySearchPractice.PerfectSquare do
  @moduledoc """
  Original implementation from my C# LeetCode solution.
  public class Solution {
    public bool IsPerfectSquare(int num) {
        var left = 0;
        var right = num;
        var result = 0;
        while(left <= right)
        {
            var mid = left + (right - left) / 2;
            if(mid == 0) left = mid + 1;
            else if (mid <= num / mid)
            {
                result = mid;
                left = mid + 1;
            }
            else
            {
                right = mid - 1;
            }
        }
        return result * result == num;
    }
  }
  """
  def is_perfect_square(n) when n < 0 do
    false
  end

  def is_perfect_square(num) do
    binary_search(0, num, 0, num)
  end

  defp binary_search(left, right, result, num) when left > right do
    result * result == num
  end

  defp binary_search(left, right, result, num) do
    mid = left + div(right - left, 2)

    cond do
      mid == 0 -> binary_search(mid + 1, right, result, num)
      mid <= div(num, mid) -> binary_search(mid + 1, right, mid, num)
      true -> binary_search(left, mid - 1, result, num)
    end
  end
end
