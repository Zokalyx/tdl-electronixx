defmodule TdlTest do
  use ExUnit.Case
  doctest Tdl

  test "greets the world" do
    assert Tdl.hello() == :world
  end
end
