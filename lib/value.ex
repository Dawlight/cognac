defmodule Cognac.Value do
  @moduledoc false

  @key_value_separator %{true: ": ", false: ?:}
  @argument_separator %{true: ", ", false: ?,}

  def build(value, pretty?), do: build_value(value, pretty?)

  defp build_value(nil, _), do: "null"
  defp build_value(value, _pretty?) when value == %{}, do: "{}"
  defp build_value({:variable, name}, _), do: ["$", to_string(name)]
  defp build_value(value, _) when is_binary(value), do: [?", value, ?"]

  defp build_value(value, pretty?) when is_struct(value) do
    build_value(Map.from_struct(value), pretty?)
  end

  defp build_value(value, pretty?) when is_map(value) do
    build_value(Map.to_list(value), pretty?)
  end

  defp build_value(value, pretty?) when is_tuple(value) do
    build_value(Tuple.to_list(value), pretty?)
  end

  defp build_value([], _pretty?), do: "[]"

  defp build_value([{_key, _value} | _] = object, pretty?) do
    [?{, build_object(object, pretty?, []), ?}]
  end

  defp build_value([_value | _] = list, pretty?), do: [?[, build_list(list, pretty?, []), ?]]
  defp build_value(value, _), do: to_string(value)

  # Object

  defp build_object([], _, _buffer), do: "{}"

  defp build_object([{key, value}], pretty?, buffer) do
    separator = @key_value_separator[pretty?]
    [build_value(value, pretty?), separator, Atom.to_string(key) | buffer] |> Enum.reverse()
  end

  defp build_object([{key, value} | rest], pretty?, buffer) do
    kvs = @key_value_separator[pretty?]
    as = @argument_separator[pretty?]
    buffer = [as, build_value(value, pretty?), kvs, Atom.to_string(key) | buffer]
    build_object(rest, pretty?, buffer)
  end

  # List

  defp build_list([value], pretty?, buffer) do
    Enum.reverse([build_value(value, pretty?) | buffer])
  end

  defp build_list([value | rest], pretty?, buffer) do
    separator = @argument_separator[pretty?]
    build_list(rest, pretty?, [separator, build_value(value, pretty?) | buffer])
  end
end
