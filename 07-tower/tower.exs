defmodule Tower do
  @example File.read!("example.txt") |> String.trim()
  @input File.read!("input.txt") |> String.trim()

  def step1(:example) do
    step1(@example)
  end
  def step1(input \\ @input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.each(&parse/1)

    find_bottom
  end

  def step2(:example) do
    step2(@example)
  end
  def step2(input \\ @input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.each(&parse/1)

    set_supporting_weights
    check_balance
    |> IO.inspect(label: "out of balance")
  end

  def parse(line) do
    case Regex.run(~r|(\w+) \((\d+)\)( -> (.+))*|, line) do
      [_, name, weight] ->
        weight = String.to_integer(weight)
        add_disc(%{name: name, weight: weight})
      [_, name, weight, _, children] ->
        weight = String.to_integer(weight)
        children =
          children
          |> String.split(",", trim: true)
          |> Enum.map(&String.trim/1)

        add_disc(%{name: name, weight: weight, children: children})

        children
        |> Enum.each(fn child -> add_disc(%{name: child, parent: name}) end)
    end
  end

  def add_disc(%{name: name} = attrs) do
    Agent.update(__MODULE__, fn discs ->
      Map.update(discs, name, attrs, fn disc ->
        Map.merge(disc, attrs)
      end)
    end)
  end

  def find_bottom do
    tower = Tower.get_tower
    {_name, disc} = tower |> Enum.random()
    find_parent(disc, tower)
  end

  defp find_parent(%{parent: parent}, tower), do: find_parent(tower[parent], tower)
  defp find_parent(disc, _tower), do: disc

  def children_weight([], tower), do: 0
  def children_weight(children, tower) when is_list(children) do
    Enum.reduce(children, 0, fn child, acc ->
      children = Map.get(tower[child], :children, [])
      acc + tower[child].weight + children_weight(children, tower)
    end)
  end
  def children_weight(parent_name, tower) do
    parent = tower[parent_name]
    parent.weight + children_weight(Map.get(parent, :children, []), tower)
  end

  def set_supporting_weights do
    tower = Tower.get_tower
    tower
    |> Enum.each(fn {name, _} ->
      Agent.update(__MODULE__, fn discs ->
        Map.update!(discs, name, &(Map.put(&1, :supporting, children_weight(name, tower))))
      end)
    end)
  end

  def find_top_unbalanced(children, tower) do
    case Enum.find(children, fn disc ->
          IO.inspect(disc, label: "checking")
          unbalanced?(disc, tower)
        end) do
      nil -> children
      disc -> find_top_unbalanced(Enum.map(disc.children, &(tower[&1])), tower)
    end
  end

  def check_balance do
    tower = Tower.get_tower
    {_name, disc} = Enum.find(tower, fn {_name, disc} -> unbalanced?(disc, tower) end)
    find_top_unbalanced(Enum.map(disc.children, &(tower[&1])), tower)
  end

  def unbalanced?(%{children: children} = disc, tower) do
    children
    |> Enum.map(&(tower[&1]))
    |> Enum.uniq_by(&(&1.supporting))
    |> Enum.count()
    |> Kernel.>(1)
  end
  def unbalanced?(_disc, _tower), do: false

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def reset do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  def get_tower do
    Agent.get(__MODULE__, &(&1))
  end
end
