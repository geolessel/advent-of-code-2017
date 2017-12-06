defmodule Memory do
  use Agent

  @input "4	1	15	12	0	9	9	5	5	8	7	3	14	5	12	3"
  
  def start_link do
    Agent.start_link(fn -> %{seen: [], count: 0} end, name: __MODULE__)
  end

  def step1(blocklist \\ @input) do
    blocklist
    |> reallocate()
    |> seen_before?()
    |> case do
         {true, blocklist} ->
           count = Agent.get(__MODULE__, &(&1.count + 1))
           IO.inspect({count, blocklist}, label: "found")
           count
         {false, blocklist} ->
           blocklist
           |> record()
           |> step1()
       end
  end

  def reallocate(blocklist) do
    banks =
      blocklist
      |> String.split(~r/\s+/, trim: true)
    |> IO.inspect(label: "blocklist")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {val, idx} -> {idx, val} end)

    {index, _} = Enum.max_by(banks, fn {_, val} -> val end)
    reallocate(banks, index)
  end

  def reallocate(banks, index) do
    {amount, banks} =
      banks
      |> Map.get_and_update(index, fn
          nil -> {0, 0}
          val -> {val, 0}
         end)
    redistribute({banks, index+1}, amount)
  end

  def redistribute({banks, _index}, amount) when amount == 0 do
    banks
    |> Map.values()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(" ")
  end
  def redistribute({banks, index}, amount) do
    case Map.get(banks, index, nil) do
      nil -> {Map.update!(banks, 0, &(&1 + 1)), 1}
      _   -> {Map.update!(banks, index, &(&1 + 1)), index+1}
    end
    |> redistribute(amount-1)
  end

  defp record(banks) do
    Agent.get_and_update(__MODULE__, fn state ->
      state =
        Map.update!(state, :seen, &([banks | &1]))
        |> Map.update!(:count, &(&1 + 1))
      {banks, state}
    end)
  end

  defp seen_before?(blocklist) do
    seen = 
      Agent.get(__MODULE__, &(&1.seen))
      |> Enum.member?(blocklist)
    IO.inspect({blocklist, seen}, label: "checking")
    {seen, blocklist}
  end
end

# Memory.start_link
# Memory.step1()
