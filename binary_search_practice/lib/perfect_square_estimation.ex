defmodule BinarySearchPractice.SquareRootEstimation do
  def estimate_square_root(value) when value === 0 do
    0
  end

  def estimate_square_root(value) do
    do_square_root_estimation(1, value, -1, value)
  end

  def do_square_root_estimation(left, right, res, _value) when left > right do
    res - 1
  end

  def do_square_root_estimation(left, right, res, value) do
    mid = floor(left + div(right - left, 2))

    cond do
      mid === div(value, mid) -> mid
      (mid * mid) > res -> do_square_root_estimation(left, mid - 1, mid, value)
      true -> do_square_root_estimation(mid + 1, right, res, value)
    end
  end
end
