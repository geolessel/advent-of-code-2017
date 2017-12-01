defmodule InverseCaptchaTest do
  use ExUnit.Case
  doctest InverseCaptcha

  test "step1 1122 produces a sum of 3" do
    assert InverseCaptcha.step1("1122") == 3
  end

  test "step1 1111 produces 4 because each digit (all 1) matches the next" do
    assert InverseCaptcha.step1("1111") == 4
  end

  test "step1 1234 produces 0 because no digit matches the next" do
    assert InverseCaptcha.step1("1234") == 0
  end

  test "step1 91212129 produces 9" do
    assert InverseCaptcha.step1("91212129") == 9
  end

  test "steps 1212 produces 6" do
    assert InverseCaptcha.step2("1212") == 6
  end

  test "step2 1221 produces 0" do
    assert InverseCaptcha.step2("1221") == 0
  end

  test "step2 123425 produces 4" do
    assert InverseCaptcha.step2("123425") == 4
  end

  test "step2 123123 produces 12" do
    assert InverseCaptcha.step2("123123") == 12
  end

  test "step2 12131415 produces 12" do
    assert InverseCaptcha.step2("12131415") == 4
  end
end
