defmodule Jumps do
  @input File.read!("input.txt") |> String.trim
  @test  File.read!("test.txt")  |> String.trim

  def step1(instructions \\ @input) do
    instructions
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> step1_loop(0, 0)
  end

  def step2(instructions \\ @input) do
    instructions
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.into(%{}, fn {val, idx} -> {idx, val} end)
    |> step2_map_loop(0, 0)
  end

  def step1_loop(list, index, step_count) do
    case Enum.at(list, index) do
      nil -> step_count
      jump ->
        list
        |> List.update_at(index, &(&1 + 1))
        |> step1_loop(index + jump, step_count + 1)
    end
  end

  # slow use of List
  def step2_list_loop(list, index, step_count) do
    case Enum.at(list, index) do
      nil -> step_count
      jump ->
        list
        |> List.update_at(index, fn(x) ->
          if x >= 3, do: x - 1, else: x + 1
        end)
        |> step2_list_loop(index + jump, step_count + 1)
    end
  end

  # MUCH faster use of Map
  def step2_map_loop(map, index, step_count) do
    case Map.get(map, index) do
      nil -> step_count
      jump ->
        map
        |> Map.update!(index, fn(x) ->
          if x >= 3, do: x - 1, else: x + 1
        end)
        |> step2_map_loop(index + jump, step_count + 1)
    end
  end
end

Jumps.step1() |> IO.inspect(label: "step1 jumps")
Jumps.step2() |> IO.inspect(label: "step2 jumps")
