defmodule CorruptionChecksum do
  @input File.read!("input.txt") |> String.trim()

  def run(rows \\ @input) do
    rows
    |> String.split("\n")
    |> Enum.map(&row_difference/1)
    |> Enum.sum()
    |> IO.inspect(label: "Checksum")
  end

  def row_difference(string) when is_binary(string) do
    list =
      string
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)

    Enum.max(list) - Enum.min(list)
  end
end

CorruptionChecksum.run
