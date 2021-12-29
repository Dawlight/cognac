defmodule CognacTest do
  use ExUnit.Case
  doctest Cognac

  test "greets the world" do
    assert Cognac.hello() == :world
  end
end
