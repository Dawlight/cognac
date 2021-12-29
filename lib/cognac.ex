defmodule Cognac do
  @moduledoc """

  """
  alias Cognac.Query

  @doc """
  Convert keyword list/tuple list to GraphQL query string

  ```elixir
  iex> query = [hero: [:name, friends: [:name]]]
  iex> Cognac.query(query) |> IO.puts
  query{hero{name friends{name}}}
  ```

  ## Options

  * `:output`
    * `:iodata` (default) - Outputs as IO data
    * `:binary` - Outputs query as a binary string
  * `pretty`
    * `false` (default) - Outputs minimal query
    * `true` - Outputs prettified query with indentation and linebreaks
  """
  @spec query(list() | keyword()) :: binary() | iodata()
  def query(query, options \\ []) do
    ["query", Query.build(query, options)]
    |> binary_or_iodata(options)
  end

  @doc """
  Convert keyword list/tuple list to GraphQL mutation query string

  ```elixir
  iex> mutation = [hero: [:name, friends: [:name]]]
  iex> Cognac.mutation(mutation) |> IO.puts
  mutation{updateHero(name:\"Steve\"){name}}
  ```

  ## Options

  * `:output`
    * `:iodata` (default) - Outputs as IO data
    * `:binary` - Outputs query as a binary string
  * `pretty`
    * `false` (default) - Outputs minimal query
    * `true` - Outputs prettified query with indentation and linebreaks
  """
  @spec mutation(list() | keyword()) :: binary() | iodata()
  def mutation(query, options \\ []) do
    ["mutation", Query.build(query, options)]
    |> binary_or_iodata(options)
  end

  @doc """
  Convert keyword list/tuple list to GraphQL subscription query string

  ```elixir
  iex> subscription = [heroUpdated: [:name]]
  iex> Cognac.subscription(subscription) |> IO.puts
  subscription{heroUpdated{name}}
  ```

  ## Options

  * `:output`
    * `:iodata` (default) - Outputs as IO data
    * `:binary` - Outputs query as a binary string
  * `pretty`
    * `false` (default) - Outputs minimal query
    * `true` - Outputs prettified query with indentation and linebreaks
  """

  @spec subscription(list() | keyword()) :: binary() | iodata()
  def subscription(query, options \\ []) do
    ["subscription", Query.build(query, options)]
    |> binary_or_iodata(options)
  end

  defp binary_or_iodata(iodata, options) do
    case options[:output] do
      :iodata -> iodata
      :binary -> IO.iodata_to_binary(iodata)
      _ -> iodata
    end
  end
end
