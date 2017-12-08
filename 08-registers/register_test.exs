Code.require_file "register.exs"
ExUnit.start

defmodule RegisterTest do
  use ExUnit.Case

  test "a inc 1 if b < 5 increases register a by 1" do
    assert Register.process_instruction("a inc 1 if b < 5", %{"b" => 0}) == %{"b" => 0, "a" => 1}
  end
end
