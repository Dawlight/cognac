defmodule Cognac.Query do
  @moduledoc false
  alias Cognac.QueryArgument

  # Pretty print delimiters
  @closing %{true: "}\n", false: ?}}
  @opening %{true: " {\n", false: ?{}
  @separator %{true: "\n", false: " "}

  def build(query, options \\ []) do
    pretty? =
      case options[:pretty] do
        nil -> false
        pretty? -> pretty?
      end

    subfields? =
      case options[:subfields] do
        nil -> true
        subfields? -> subfields?
      end

    [@opening[pretty?], build_fields(query, 1, pretty?, subfields?), ?}]
  end

  defp build_fields(query, level, pretty?, subfields?) when is_map(query) do
    build_fields(Map.to_list(query), level, pretty?, subfields?)
  end

  defp build_fields(query, level, pretty?, subfields?),
    do: build_fields(query, level, pretty?, subfields?, [])

  defp build_fields([], _level, _pretty?, _subfields?, buffer), do: Enum.reverse(buffer)

  defp build_fields(
         [{field, {arguments, sub_fields}} | rest],
         level,
         pretty?,
         true = subfields?,
         buffer
       ) do
    field = field |> to_string() |> indent(level, pretty?)
    nested_fields = build_fields(sub_fields, level + 1, pretty?, subfields?)
    arguments = QueryArgument.build(arguments, pretty?)
    closing = indent(@closing[pretty?], level, pretty?)

    buffer = [closing, nested_fields, @opening[pretty?], arguments, field | buffer]
    build_fields(rest, level + 1, pretty?, subfields?, buffer)
  end

  defp build_fields([{field, sub_fields} | rest], level, pretty?, true = subfields?, buffer) do
    field = field |> to_string() |> indent(level, pretty?)
    nested_fields = build_fields(sub_fields, level + 1, pretty?, subfields?)
    closing = indent(@closing[pretty?], level, pretty?)

    buffer = [closing, nested_fields, @opening[pretty?], field | buffer]
    build_fields(rest, level + 1, pretty?, subfields?, buffer)
  end

  defp build_fields([{field, arguments} | rest], level, pretty?, false = subfields?, buffer) do
    field = field |> to_string() |> indent(level, pretty?)
    arguments = QueryArgument.build(arguments, pretty?)

    buffer = [arguments, field | buffer]
    build_fields(rest, level + 1, pretty?, subfields?, buffer)
  end

  defp build_fields([field], level, pretty?, _subfields?, buffer) do
    field = field |> to_string() |> indent(level, pretty?)
    field = if pretty?, do: [field, "\n"], else: field

    Enum.reverse([field | buffer])
  end

  defp build_fields([field | rest], level, pretty?, subfields?, buffer) do
    field = field |> to_string() |> indent(level, pretty?)
    separator = @separator[pretty?]

    build_fields(rest, level, pretty?, subfields?, [separator, field | buffer])
  end

  defp indent(iodata, level, true), do: [String.duplicate("  ", level), iodata]
  defp indent(iodata, _level, false), do: iodata
end
