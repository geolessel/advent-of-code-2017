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

  test "step2 abcde fghij is valid" do
    assert Passphrase.valid?("abcde fghij", :step2)
  end

  test "step2 abcde xyz ecdab is not valid" do
    refute Passphrase.valid?("abcde xyz ecdab", :step2)
  end

  test "step2 a ab abc abd abf abj is valid" do
    assert Passphrase.valid?("a ab abc abd abf abj", :step2)
  end

  test "step2 iiii oiii ooii oooi oooo is valid" do
    assert Passphrase.valid?("iiii oiii ooii oooi oooo", :step2)
  end

  test "step2 oiii ioii iioi iiio is not valid" do
    refute Passphrase.valid?("oiii ioii iioi iiio", :step2)
  end
end
