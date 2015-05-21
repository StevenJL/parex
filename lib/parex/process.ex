require IEx

defmodule Parex.Process do
  def init(sender, process) do
    result = execute(process)

    send sender, {:ok, result} 
  end

  def execute(process) do
    {name, func} = process
     
    {name, func.()} 
  end
end

