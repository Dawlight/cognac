defmodule CognacTest do
  use ExUnit.Case

  test "test" do
    fields = [:fooo, bar: [:baz]]
    arguments = %{"foo" => "bar"}

    Cognac.query([stuff: {arguments, fields}], output: :binary, pretty: true)
  end
end
