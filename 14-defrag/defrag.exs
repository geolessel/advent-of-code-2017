defmodule Defrag do
  def hex_to_binary(hex) when byte_size(hex) == 1 do
    {base10, _} = Integer.parse(hex, 16)
    Integer.to_string(base10, 2) |> String.pad_leading(4, "0")
  end
  def hex_to_binary(hex) do
    hex
    |> String.split("", trim: true)
    |> IO.inspect(label: "split")
    |> Enum.map(&hex_to_binary/1)
  end
end
