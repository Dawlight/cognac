# Cognac

Build GraphQL queries efficiently without string mashing. Pairs well with [Absinthe](https://github.com/absinthe-graphql/absinthe).

## Usage

Add Cognac as a dependency in your `mix.exs` file:

```elixir
def deps do
  [{:cognac, "~> 0.7.0"}]
end
```

Then, run `mix deps.get` in your shell to fetch and compile Cognac. Start an interactive Elixir shell with `iex -S mix`.

```elixir
iex> alias Cognac, as: C
iex> query = [hero: [:name, friends: [:name]]]
iex> C.query(query) |> IO.puts
query{hero{name friends{name}}}
```

# Examples

In the current version, only simple queries, mutations and subscriptions are possible. Operation names and variables will be added in a future release.

## Basic query

```elixir
iex> query = [hero: [:name, friends: [:name]]]
iex> Cognac.query(query) |> IO.puts
query{hero{name friends{name}}}
```

Fields can also be specified using strings, albeit not as readably.

```elixir
iex> query = [{"hero", ["name", {"friends", ["name"]}]}]
iex> Cognac.query(query) |> IO.puts
query{hero{name friends{name}}}
```

## Query with parameters

Parameters are specified by assigning a tuple to a key, where the first element is a keyword list of parameters, and the second element is a list of subfields.

```elixir
iex> query = [heroes: {[name: "Steve", paginate: nil],[:name, friends: [:name]]}]
iex> Cognac.query(query) |> IO.puts
query{heroes(name:"Steve",paginate:null){name friends{name}}}
```

Which can be achieved at any level

```elixir
iex> query = [heroes: {[name: "Steve", paginate: nil],[:name, friends: {[class: :WARRIOR],[:name]}]}]
iex> Cognac.query(query) |> IO.puts
query{heroes(name:"Steve",paginate:null){name friends(class:WARRIOR){name}}}
```

Note that atom values are handled processed as unescaped strings, which can be useful for enumerable type values

# Options

Use the `:output` option to either get the result as `:iodata` (default) or a `:binary` string.

```elixir
iex> query = [hero: [:name, friends: [:name]]]
iex> Cognac.query(query, output: :iodata)
[
  "query",
  [123, ["hero", 123, ["name", " ", "friends", 123, ["name"], 125], 125], 125]
]
iex> Cognac.query(query, output: :binary)
"query{hero{name friends{name}}}"
```

Use the `:pretty` option (defaults to `false`) to introduce indentation and line breaks which could possibly help with debugging.

```elixir
iex> query = [hero: [:name, friends: [:name]]]
iex> Cognac.query(query, pretty: true) |> IO.puts
query {
  hero {
    name
    friends {
      name
    }
  }
}
```
