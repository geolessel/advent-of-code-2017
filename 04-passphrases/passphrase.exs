defmodule Passphrase do
  @input File.read!("input.txt") |> String.trim()

  def step1(phrases \\ @input) do
    phrases
    |> String.split("\n")
    |> Enum.reduce(0, &(if valid?(&1, :step1), do: &2 + 1, else: &2))
  end

  def step2(phrases \\ @input) do
    phrases
    |> String.split("\n")
    |> Enum.reduce(0, &(if valid?(&1, :step2), do: &2 + 1, else: &2))
  end

  def valid?(phrase, :step1) do
    phrase
    |> String.split()
    |> Enum.group_by(&(&1))
    |> Enum.reduce(0, fn({_key, val}, acc) ->
      if Enum.count(val) > 1, do: acc + 1, else: acc
    end)
    |> Kernel.==(0)
  end

  def valid?(phrase, :step2) do
    phrases =
      phrase
      |> String.split()
      |> Enum.map(fn(phrase) ->
        phrase
        |> String.split("", trim: true)
        |> Enum.sort()
      end)

    phrases
    |> Enum.reduce(0, fn(phrase, acc) ->
      if Enum.count(phrases, &(&1 == phrase)) > 1 do
        acc + 1
      else
        acc
      end
    end)
    |> Kernel.==(0)
  end
end

Passphrase.step1() |> IO.inspect(label: "step1 valid passphrases")
Passphrase.step2() |> IO.inspect(label: "step2 valid passphrases")
