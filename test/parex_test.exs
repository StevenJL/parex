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
end
