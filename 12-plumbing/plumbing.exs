defmodule Plumbing do
  @input File.read!("input.txt") |> String.trim()
  @example File.read!("example.txt") |> String.trim()

  def step1, do: step1(@input)
  def step1(:example), do: step1(@example)
  def step1(input) do
    connections =
      input
      |> String.split("\n")
      |> connections()
      # |> IO.inspect(label: "connections")
    find_connections_to(connections, 0)
    |> Enum.count()
    |> IO.inspect(label: "# of programs connected to 0")
  end

  def step2, do: step2(@input)
  def step2(:example), do: step2(@example)
  def step2(input) do
    connections =
      input
      |> String.split("\n")
      |> connections()

    IO.puts "created plumbing map. looking for connections..."

    find_groups(connections, 0)
  end
  
  def connections(list) when is_list(list), do: connections(%{}, list)
  def connections(map, []), do: map
  def connections(map, [head | tail]) do
    [_, parent, children] = Regex.run(~r|^(\d+) <-> ([0-9, ]+)|, head)

    parent = String.to_integer(parent)
    children = String.split(children, ", ") |> Enum.map(&(String.to_integer/1))

    Map.update(map, parent, children, fn pipe ->
      children ++ pipe
    end)
    |> connections(tail)
  end

  def find_connections_to(programs, id) do
    programs
    |> Enum.filter(fn {program, connections} ->
      # if program == 1237, do:
      #   IO.inspect({program, connections}, label: "program, connections")
      connected_to?(connections, id, programs, [])
    end)
    |> Enum.into(%{})
    |> Map.keys()
  end

  def find_groups(programs, id), do: find_groups(programs, id, [])
  def find_groups(programs, _id, found) when programs == %{}, do: found |> IO.inspect(label: "found")
  def find_groups(programs, id, found) do
    IO.puts "finding group with id #{id}"
    connections = find_connections_to(programs, id)
    unconnected = Map.drop(programs, connections)
    find_groups(unconnected, List.first(Map.keys(unconnected)), [id | found])
  end

  def connected_to?([], _id, _programs, _checked), do: false
  def connected_to?([id | _tail], id, _programs, _checked), do: true
  def connected_to?([head | tail], id, programs, checked) do
    # IO.inspect({head, checked}, label: "checking")

    unchecked_programs = Map.drop(programs, checked)

    children = 
      unchecked_programs
      |> Map.get(head, [])

    # IO.inspect(children ++ tail, label: "children ++ tail")

    connected_to?(children ++ tail, id, programs, [head | checked])
  end
end
