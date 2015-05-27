require IEx

defmodule Parex.Process do
  def init(sender, process) do
    result = execute(process)

    send sender, {:ok, result} 
  end

  def execute(process) when is_tuple(process) do
    {name, func} = process
     
    {name, func.()} 
  end

  def execute(process) when is_map(process) do
    key = process |> Map.keys |> List.first
    func = Map.get(process, key)

    Map.put(process, key, func.())
  end
end

