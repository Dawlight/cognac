defmodule Cognac.Helpers do
  @moduledoc false
  @doc """
  Marks value as variable, helping with correct annotation using ($) and all that jazz.
  """
  defmacro variable(name) when is_binary(name) do
    quote do: {:variable, unquote(name)}
  end

  @doc """
  Marks type as non-null, appending with an exclamation mark (!).
  """
  defmacro non_null(type) do
    quote do: [to_string(unquote(type)), ?!]
  end

  @doc """
  Creates a typle of a string-based field with subfield
  """
  defmacro field(field, sub_fields) do
    quote do: {to_string(unquote(field)), unquote(sub_fields)}
  end
end
