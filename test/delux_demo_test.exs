defmodule DeluxDemoTest do
  use ExUnit.Case
  doctest DeluxDemo

  test "greets the world" do
    assert DeluxDemo.hello() == :world
  end
end
