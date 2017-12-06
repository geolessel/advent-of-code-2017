defmodule Memory do
  use Agent

  @input "4 1 15 12 0 9 9 5 5 8 7 3 14 5 12 3"
  
  def run(["--all"]) do
    Memory.start
    Memory.step1() |> IO.inspect(label: "step1")
    Memory.reset
    Memory.step2() |> IO.inspect(label: "step2")
  end
  def run(["--step1"]) do
    Memory.start
    Memory.step1() |> IO.inspect(label: "step1")
  end
  def run(["--step2"]) do
    Memory.start
    Memory.step2() |> IO.inspect(label: "step2")
  end
  def run(_) do
    IO.puts("USAGE: elixir memory.exs --all|step1|step2")
  end

  def start do
    Agent.start_link(fn -> %{seen: [], count: 0} end, name: __MODULE__)
  end

  def step1(blocklist \\ @input) do
    blocklist
    |> reallocate()
    |> seen_before?()
    |> case do
         {true, _blocklist} ->
           count = Agent.get(__MODULE__, &(&1.count + 1))
           count
         {false, blocklist} ->
           blocklist
           |> record()
           |> step1()
       end
  end

  def step2(blocklist \\ @input) do
    blocklist
    |> record(:step2)
    |> reallocate()
    |> seen_before?(:step2)
    |> case do
         {%{index: index}, _blocklist} ->
           %{count: count} = Agent.get(__MODULE__, &(&1))
           count - index
         {false, blocklist} ->
           blocklist
           |> step2()
       end
  end

  def reallocate(blocklist) do
    banks =
      blocklist
      |> String.split(~r/\s+/, trim: true)
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

  defp record(banks, :step2) do
    Agent.get_and_update(__MODULE__, fn state ->
      state =
        Map.update!(state, :seen, &([%{index: state.count, banks: banks} | &1]))
        |> Map.update!(:count, &(&1 + 1))
      {banks, state}
    end)
  end

  def reset do
    Agent.update(__MODULE__, fn _ -> %{seen: [], count: 0} end)
  end

  defp seen_before?(blocklist) do
    seen = 
      Agent.get(__MODULE__, &(&1.seen))
      |> Enum.member?(blocklist)
    {seen, blocklist}
  end

  defp seen_before?(blocklist, :step2) do
    seen =
      Agent.get(__MODULE__, &(&1.seen))
      |> Enum.find(false, fn %{banks: banks} -> banks == blocklist end)
    {seen, blocklist}
  end
end

System.argv
|> Memory.run()
