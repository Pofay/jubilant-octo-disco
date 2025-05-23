defmodule BinarySearchPractice.NewsPapers do
  def feasible(newspaper_read_times, num_coworkers, limit) do
    calculate_number_of_workers(newspaper_read_times, limit) <= num_coworkers
  end

  defp calculate_number_of_workers(newspaper_read_times, limit) do
    {time, number_of_workers} =
      Enum.reduce(newspaper_read_times, {0, 0}, fn read_time, {time, number_of_workers} ->
        if(time + read_time > limit) do
          {read_time, number_of_workers + 1}
        else
          {time + read_time, number_of_workers}
        end
      end)

    if time != 0 do
      number_of_workers + 1
    else
      number_of_workers
    end
  end

  def newspapers_split(newspaper_read_times, num_of_coworkers) do
    do_binary_search(
      Enum.max(newspaper_read_times),
      Enum.sum(newspaper_read_times),
      -1,
      newspaper_read_times,
      num_of_coworkers
    )
  end

  defp do_binary_search(low, high, answer, _newspaper_read_times, _num_of_coworkers)
       when low > high do
    answer
  end

  defp do_binary_search(low, high, answer, newspaper_read_times, num_of_coworkers) do
    mid = low + div(high - low, 2)

    if feasible(newspaper_read_times, num_of_coworkers, mid) do
      do_binary_search(low, mid - 1, mid, newspaper_read_times, num_of_coworkers)
    else
      do_binary_search(mid + 1, high, answer, newspaper_read_times, num_of_coworkers)
    end
  end
end
