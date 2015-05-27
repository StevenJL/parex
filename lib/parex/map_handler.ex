defmodule Parex.MapHandler do
  def parallel_execute(processes) do
    process_tuples = processes
      |> Map.keys 
      |> Enum.map fn(key) -> {key, Map.get(processes, key)} end

    process_tuples 
      |> Enum.each fn(process_tuple) -> spawn_link(Parex.Process, :init, [self, process_tuple]) end

    gather_results(%{}, length process_tuples)
  end

  defp gather_results(results, 0) do
    results
  end

  defp gather_results(results, num_results_expected) do
    receive do
      {:ok, result_tuple} -> gather_results(
                               merge_result(result_tuple, results), 
                               num_results_expected - 1
                             )
    end
  end

  defp merge_result(result_tuple, results) do
    {key, result} =  result_tuple
    Map.put(results, key, result)
  end
end

