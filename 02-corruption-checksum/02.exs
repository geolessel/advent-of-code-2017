defmodule CorruptionChecksum do
  @input File.read!("input.txt") |> String.trim()

  def run(rows \\ @input) do
    rows
    |> String.split("\n")
    |> Enum.map(&row_difference/1)
    |> Enum.sum()
    |> IO.inspect(label: "Part 1 Checksum")

    rows
    |> String.split("\n")
    |> Enum.map(&divisible_difference/1)
    |> Enum.sum()
    |> IO.inspect(label: "Part 2 Checksum")
  end

  def row_difference(string) when is_binary(string) do
    list = row_as_list(string)
    Enum.max(list) - Enum.min(list)
  end

  def divisible_difference(string) do
    list = row_as_list(string)
    count = Enum.count(list)

    list
    |> Enum.with_index()
    # |> IO.inspect()
    |> Enum.find_value(fn ({x, i}) ->
      y = Enum.find(Enum.slice(list, i+1..count), fn(y) ->
        rem(x, y) == 0 || rem(y, x) == 0
      end)
      if y do
        [x, y] = Enum.sort([x, y]) |> Enum.reverse
        div(x, y)
      end
    end)
    # |> IO.inspect()
  end

  def row_as_list(string) do
    string
    |> String.split(~r/\s+/)
    |> Enum.map(&String.to_integer/1)
  end
end

CorruptionChecksum.run

# CorruptionChecksum.divisible_difference("5 9 2 8")
