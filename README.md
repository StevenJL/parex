Parex
=====
[![Build Status](https://travis-ci.org/StevenJL/parex.svg)](https://travis-ci.org/StevenJL/parex)

**Par**allel **Ex**ecute (Parex) is an Elixir module for executing multiple (slow) processes in parallel.

### Installation
Put this in your `mix.exs` `deps`

```elixir
defp deps do
[
  ... # other dependencies
  {:parex, github: "stevenjl/parex", tag: "v0.0.2"}
]
```

### Usage
`Parex.parallel_execute/1` takes a keyword list of functions and executes them in parallel.

```elixir
Parex.parallel_execute([
    fibonacci: fn() -> Math.fib(40) end,
         hang: fn() -> :timer.sleep(5000) end,
  web_request: fn() -> HTTPotion.get("http://wwww.reddit.com") end
])
# => [web_request: %HTTPotion.Response{body...}, hang: :ok, fibonacci: 102334155]
```

It also works with a list of maps

```elixir
Parex.parallel_execute([
    %{ fibonacci: fn() -> Math.fib(40) end},
    %{ hang: fn() -> :timer.sleep(5000) end},
    %{ web_request: fn() -> HTTPotion.get("http://wwww.reddit.com") end}
])
# => [%{web_request: %HTTPotion.Response{body...}}, %{hang: :ok}, %{fibonacci: 102334155}]
```

It also works with a single map whose key-value pairs are functions

```elixir
Parex.parallel_execute(
    %{ 
       fibonacci: fn() -> Math.fib(40) end,
       hang: fn() -> :timer.sleep(5000) end,
       web_request: fn() -> HTTPotion.get("http://wwww.reddit.com") end
     }
)
# => %{ web_request: %HTTPotion.Response{body...}, hang: :ok, fibonacci: 102334155 }
```

### Compared to executing in series:
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
```

Now let's run them in parallel.

```elixir
{time, _ } = :timer.tc(
  fn ->
    Parex.parallel_execute([
           fib_num: fn() -> Math.fib(40) end,
          fib_num2: fn() -> Math.fib(35) end,
             hang1: fn() -> :timer.sleep(1000) end,
             hang2: fn() -> :timer.sleep(5000) end,
      web_request1: fn() -> HTTPotion.get("http://www.reddit.com") end,
      web_request2: fn() -> HTTPotion.get("http://bleacherreport.com") end,
      web_request3: fn() -> HTTPotion.get("http://www.elixir-lang.org") end
    ])
  end
)
time #=> 5532994
```
Obviously, parallel is faster, as it's just the time of the slowest process (most likely the fibonacci computation in this case), rather than the sum of all process times.

See the [tests for more examples](https://github.com/StevenJL/parex/blob/master/test/parex_test.exs).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

(The MIT License)

Copyright © 2014 Steven Li

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
‘Software’), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

