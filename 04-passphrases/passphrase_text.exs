Code.require_file "passphrase.exs"

ExUnit.start

defmodule PassphraseTest do
  use ExUnit.Case, async: true

  test "step1 aa bb cc dd ee is valid" do
    assert Passphrase.valid?("aa bb cc dd ee", :step1)
  end

  test "step1 aa bb cc dd aa is not valid" do
    refute Passphrase.valid?("aa bb cc dd aa", :step1)
  end

  test "step1 aa bb cc dd aaa is valid" do
    assert Passphrase.valid?("aa bb cc dd aaa", :step1)
  end
end
