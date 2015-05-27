defmodule ParexTest do
  use ExUnit.Case

  test "it returns results for functions" do
    results = Parex.parallel_execute([
      add: fn() -> 1+1 end, 
      greet: fn() -> "Hi!" end
    ])       
    assert Keyword.get(results, :add) == 2
    assert Keyword.get(results, :greet) == "Hi!"
  end

  test "it should run functions in parallel" do
    {time, _} = :timer.tc(
      fn -> 
        Parex.parallel_execute([
          hang1: fn() -> :timer.sleep(5000) end,
          hang2: fn() -> :timer.sleep(4000) end,
          hang3: fn() -> :timer.sleep(3000) end,
          hang4: fn() -> :timer.sleep(2000) end
        ]) 
      end
    )
    microseconds_per_milliseconds = 1000
    # :timer.tc returns microseconds 
    # :timer.sleep takes milliseconds

    epsilon = 5
    # It's not perfectly parallel, there is a minor overhead

    assert time < (5000 + epsilon)*microseconds_per_milliseconds
  end

  test "it also works for a list of maps" do
    results = Parex.parallel_execute([
      %{"add" => fn() -> :timer.sleep(1000); 1+1 end},
      %{"greet" => fn() -> :timer.sleep(4000); "Hi!" end}
    ])

    assert results == [%{"greet" => "Hi!"}, %{"add" => 2}]
  end

  test "it also works for a single map where the functions are key-values" do
    results = Parex.parallel_execute(
      %{ add: fn() -> 1+1 end,
         greet: fn() -> "Hi!" end
       }
    )

    assert results == %{add: 2, greet: "Hi!"}
  end
end

