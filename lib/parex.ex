defmodule Parex do
  def parallel_execute(processes) when is_list(processes) do
    Parex.ListHandler.parallel_execute(processes)
  end

  def parallel_execute(processes) when is_map(processes) do
    Parex.MapHandler.parallel_execute(processes)
  end
end

