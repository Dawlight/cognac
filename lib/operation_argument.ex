defmodule Cognac.OperationArgument do
  @moduledoc false
  alias Cognac.Value

  @key_value_separator %{true: ": ", false: ?:}
  @default_assign %{true: " = ", false: ?=}
  @closing %{true: ") ", false: ?)}
  @separator %{true: " ", false: ""}

  def build(arguments \\ [], options \\ [])

  def build(arguments, options) when is_map(arguments) do
    build(Map.to_list(arguments), options)
  end

  def build(arguments, options) do
    pretty? =
      case options[:pretty] do
        nil -> false
        pretty? -> pretty?
      end

    build_arguments(arguments, pretty?)
  end

  defp build_arguments([], pretty?), do: @separator[pretty?]
  defp build_arguments(arguments, pretty?), do: build_arguments(arguments, pretty?, [])

  defp build_arguments([{name, type, default}], pretty?, buffer) do
    default = Value.build(default, pretty?)
    type = to_string(type)
    name = build_name(to_string(name))
    assign = @default_assign[pretty?]
    kvs = @key_value_separator[pretty?]
    closing = @closing[pretty?]

    [?(, [default, assign, type, kvs, name | buffer] |> Enum.reverse(), closing]
  end

  defp build_arguments([{name, type}], pretty?, buffer) do
    type = to_string(type)
    name = build_name(to_string(name))
    kvs = @key_value_separator[pretty?]
    closing = @closing[pretty?]

    [?(, [type, kvs, name | buffer] |> Enum.reverse(), closing]
  end

  defp build_arguments([{name, type, default} | rest], pretty?, buffer) do
    default = Value.build(default, pretty?)
    type = to_string(type)
    name = build_name(to_string(name))
    assign = @default_assign[pretty?]
    kvs = @key_value_separator[pretty?]

    build_arguments(rest, [default, assign, type, kvs, name | buffer])
  end

  defp build_arguments([{name, type} | rest], pretty?, buffer) do
    type = to_string(type)
    name = build_name(to_string(name))
    kvs = @key_value_separator[pretty?]

    build_arguments(rest, pretty?, [type, kvs, name | buffer])
  end

  defp build_name(<<?$, name::binary>>), do: name
  defp build_name(name), do: [?$, name]
end
