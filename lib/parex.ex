require IEx

defmodule Parex do
  def parallel_execute(processes) do
    processes |> Enum.each fn process ->
      spawn_link(Parex.Process, :init, [self, process])
    end

    gather_results([], length processes)
  end

  defp gather_results(results, 0) do
    results
  end

  defp gather_results(results, num_results_expected) do
    receive do
      {:ok, result} -> gather_results([result | results], num_results_expected - 1)
    end
  end
end

