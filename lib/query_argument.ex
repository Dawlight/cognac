defmodule Cognac.QueryArgument do
  @moduledoc false
  alias Cognac.Value

  @key_value_separator %{true: ": ", false: ?:}
  @argument_separator %{true: ", ", false: ?,}

  def build(arguments, pretty?), do: build_arguments(arguments, pretty?)

  defp build_arguments(arguments, pretty?) when is_map(arguments) do
    build_arguments(Map.to_list(arguments), pretty?)
  end

  defp build_arguments(arguments, pretty?) do
    [?(, build_arguments(arguments, pretty?, []), ?)]
  end

  defp build_arguments([{key, value}], pretty?, buffer) do
    kvs = @key_value_separator[pretty?]
    [Value.build(value, pretty?), kvs, to_string(key) | buffer] |> Enum.reverse()
  end

  defp build_arguments([{key, value} | rest], pretty?, buffer) do
    as = @argument_separator[pretty?]
    kvs = @key_value_separator[pretty?]

    buffer = [as, Value.build(value, pretty?), kvs, to_string(key) | buffer]
    build_arguments(rest, pretty?, buffer)
  end
end
