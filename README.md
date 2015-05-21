Parex
=====

**Par**allel **Ex**ecute (Parex) is an Elixir module for executing multiple (slow) processes in parallel.

### Usage
`Parex.parllel_execute/1` takes a keyword list of functions and executes them in parallel.

```elixir
Parex.parallel_execute([
  fibonacci: fn() -> Math.fib(40) end,
  hang: fn() -> :timer.sleep(5000) end,
  web_request: fn() -> HTTPotion.get("http://wwww.reddit.com") end
])
# => [web_request: %HTTPotion.Response{body...}, time_out: :ok, fibonacci: 102334155]
```

##### Compared to executing in series:
Let's run a few slow functions in series.

```elixir
{time, _ } = :timer.tc(
  fn ->
    fib_num = Math.fib(40)
    fib_num2 = Math.fib(35)
    hang1 = :timer.sleep(1000)
    hang2 = :timer.sleep(5000)
    web_request1 = HTTPotion.get("http://www.reddit.com")
    web_request2 = HTTPotion.get("http://bleacherreport.com")
    web_request3 = HTTPotion.get("http://www.elixir-lang.org")
  end
)
time #=> 12920554
# Note the cumulative time is the sum of all process times
```

Now let's run them in parallel.

```elixir
{time, _ } = :timer.tc(
  fn ->
    Parex.parallel_execute([
      fib_num: fn() -> Math.fib(40) end,
      fib_num2: fn() -> Math.fib(35) end,
      hang1: fn() -> :timer.sleep(1000) end,
      hang2: fn() -> :timer.sleep(1000) end,
      web_request1: fn() -> HTTPotion.get("http://www.reddit.com") end,
      web_request2: fn() -> HTTPotion.get("http://bleacherreport.com") end,
      web_request3: fn() -> HTTPotion.get("http://www.elixir-lang.org") end
    ])
  end
)
time #=> 5532994
```
Obviously, parallel is faster, as it's just the time of the slowest process (probably the fibonacci computation), rather than the sum of all process times.

