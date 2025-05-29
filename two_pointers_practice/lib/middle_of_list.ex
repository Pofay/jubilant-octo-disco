defmodule TwoPointersPractice.MiddleOfList do
  def find_middle(list) do
    do_find_middle(list, list)
  end

  defp do_find_middle(slow, []) do
    hd(slow)
  end

  defp do_find_middle(slow, [_]) do
    hd(slow)
  end

  defp do_find_middle([_ | slow], [_, _ | fast]) do
    do_find_middle(slow, fast)
  end
end
