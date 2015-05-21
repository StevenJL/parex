Parex
=====

_Par_allel _Ex_ecute (Parex) is an Elixir library for executing multiple (slow) processes in parallel.

### Usage
`Parex.parllel_execute/1` takes a keyword list of functions and executes them in parallel.

```
Parex.parallel_execute([
  fibonacci: fn() -> Math.fib(40) end,
  timeout: fn() -> :timer.sleep(5000) end,
  web_request: fn() -> HTTPotion.get("http://wwww.reddit.com") end
])
# => [web_request: %HTTPotion.Response{body...}, time_out: :ok, fibonacci: 102334155]
```

##### Compared to executing in series:
```
{time, _ } = :timer.tc(
  fn ->
    fib_num = Math.fib(40)
    timeout = :timer.sleep(1000)
     
  end
)
time #=> 10777737
```
Running in series, the cumulative time is sum of all process times.

```
{time, _ } = :timer.tc(
  fn ->
    Parex.parallel_execute([
      fibonacci: fn() -> Math.fib(40) end,
      timeout: fn() -> :timer.sleep(5000) end,
      web_request: fn() -> HTTPotion.get("http://www.reddit.com") end
    ])
  end
)
time #=> 5483184
```
Running in parallel, the time the max process time, which in this case, is probably the Fibonacci computation.

