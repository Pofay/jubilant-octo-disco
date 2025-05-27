defmodule TwoPointersPractice.RemoveDuplicates do
  def remove_duplicates([]) do
    []
  end

  def remove_duplicates([head | tail]) do
    do_remove_duplicates([head | tail], 1, 0, [head])
    |> Enum.reverse()
  end

  defp do_remove_duplicates(list, fast, _slow, acc) when fast >= length(list) do
    acc
  end

  # defp do_remove_duplicates([h | t], last_value, acc) do
  #   if h === last_value do
  #     do_remove_duplicates(t, last_value, acc)
  #   else
  #     do_remove_duplicates(t, h, [h | acc])
  #   end
  # end

  defp do_remove_duplicates(list, fast, slow, acc) do
    fast_value = Enum.at(list, fast)
    slow_value = Enum.at(list, slow)

    if fast_value != slow_value do
      do_remove_duplicates(list, fast + 1, fast, [fast_value | acc])
    else
      do_remove_duplicates(list, fast + 1, slow, acc)
    end
  end
end
