Code.require_file "memory.exs"

ExUnit.start

defmodule MemoryTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = Memory.start
    :ok
  end

  test "0270 reallocates to 2412" do
    assert Memory.reallocate("0 2 7 0") == "2 4 1 2"
  end

  test "2412 reallocates to 3123" do
    assert Memory.reallocate("2 4 1 2") == "3 1 2 3"
  end

  test "0270 is seen on 5th reallocation" do
    assert Memory.step1("0 2 7 0") == 5
  end

  test "0270 has a cycle of 4" do
    assert Memory.step2("0 2 7 0") == 4
  end
end
