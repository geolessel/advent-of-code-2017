defmodule Scanners do
  def step1, do: step1(input())
  def step1(:example), do: step1(example())
  def step1(input) do
    layers = setup_map(input)
    {max, _} = Enum.max_by(layers, fn {key, _} -> key end)

    0..max
    |> Enum.reduce(%{packet: -1, layers: layers, caught: 0, severity: 0}, fn i, acc ->
      acc
      |> move_packet()
      |> update_caught_severity()
      |> step_layers(i)
    end)
    |> Map.get(:severity)
    |> IO.inspect(label: "severity")
  end

  def step2, do: step2(input())
  def step2(:example), do: step2(example())
  def step2(input) do
    layers = setup_map(input)
    {max, _} = Enum.max_by(layers, fn {key, _} -> key end)
  
    Stream.iterate(0, & &1 + 1)
    # 0..12
    |> Enum.find(fn delay ->
      packet = 0 - 1 # |> IO.inspect(label: "packet")

      if rem(delay, 50) == 0, do:
        IO.puts delay

      0..max
      |> Enum.reduce(%{packet: packet, layers: layers, caught: 0, severity: 0}, fn i, acc ->
        acc
        |> step_layers(i + delay)
        |> move_packet()
        # |> IO.inspect(label: "packet moved")
        |> update_caught_severity()
        |> step_layers(i + delay)
        # |> IO.inspect(label: "step moved with step #{i + delay}")
      end)
      # |> IO.inspect(label: "winner")
      |> Map.get(:caught)
      |> Kernel.==(0)
    end)
    |> IO.inspect(label: "delay required")
  end

  def move_packet(%{packet: packet} = state) do
    %{state | packet: packet + 1}
  end

  def update_caught_severity(%{packet: packet, layers: layers} = state) do 
    case Map.get(layers, packet) do
      %{at: 0} = layer -> 
        # IO.inspect layer, label: "caught at #{packet}"
        state
        |> Map.update!(:caught, fn caught -> caught + 1 end)
        |> Map.update!(:severity, fn severity -> severity + (layer.range + 1) * packet end)
      _ -> state
    end
  end

  def setup_map(input), do: setup_map(%{}, input)
  def setup_map(layers, []), do: layers
  def setup_map(layers, [layer | tail]) do
    [_, depth, range] = Regex.run(~r|(\d+): (\d+)|, String.trim(layer))
    Map.put(
      layers,
      String.to_integer(depth),
      %{
        range: String.to_integer(range) - 1,
        at: 0,
        func: :add
      }
    )
    |> setup_map(tail)
  end

  def step_layers(%{layers: layers} = state, step), do: %{state | layers: step_layers(layers, Map.to_list(layers), step)}
  def step_layers(layers, [], _step), do: layers

  def step_layers(layers, [{layer, %{range: range} = attrs} | tail], step) do
    test_range = range
    max_steps = test_range * 2
    step_in_range = rem(step, max_steps)
    at =
      cond do
        step_in_range < test_range -> step_in_range
        step_in_range >= test_range -> test_range - (step_in_range - range)
      end
    # |> IO.inspect(label: "step_in_range")
    # IO.inspect({test_range, step, rem(step, max_steps)})

    layers
    |> Map.put(layer, %{attrs | at: at})
    |> step_layers(tail, step)
  end

  #   IO.inspect(div(rem(range*2, step), step), label: "guard")
  #   layers
  #   |> Map.put(layer, %{range: range, at: at + 1, func: :add})
  #   |> step_layers(tail, step+1)
  # end
  # def step_layers(layers, [{layer, %{range: range, at: at}} | tail], step) when div((range) * 2, step) < range do
  #   IO.puts "range * 2: #{range * 2}, step < range: #{div((range + 1) * 2, step)}, step: #{step}, layer: #{layer}"

  #   layers
  #   |> Map.put(layer, %{range: range, at: at + 1, func: :add})
  #   |> step_layers(tail, step+1)
  # end
  # def step_layers(layers, [{layer, %{range: range, at: range, func: :add}} | tail], step) do
  #   layers
  #   |> Map.put(layer, %{range: range, at: range - 1, func: :sub})
  #   |> step_layers(tail, step+1)
  # end
  # def step_layers(layers, [{layer, %{range: range, at: 0, func: :sub}} | tail], step) do
  #   layers
  #   |> Map.put(layer, %{range: range, at: 1, func: :add})
  #   |> step_layers(tail, step+1)
  # end
  # def step_layers(layers, [{layer, %{at: at, func: :add} = attrs} | tail], step) do
  #   layers
  #   |> Map.put(layer, %{attrs | at: at + 1})
  #   |> step_layers(tail, step+1)
  # end
  # def step_layers(layers, [{layer, %{at: at, func: :sub} = attrs} | tail], step) do
  #   layers
  #   |> Map.put(layer, %{attrs | at: at - 1})
  #   |> step_layers(tail, step+1)
  # end

  def example do
    "0: 3\n1: 2\n4: 4\n6: 4"
    |> String.split("\n")
  end

  def input do
    File.read!("input.txt") |> String.trim() |> String.split("\n")
  end
end
