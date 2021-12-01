defmodule StreamProcessing do
  def garbage?(input) do
    Regex.match?(~r|^<.*>$|, input)
  end

  def group?(input) do
    Regex.run(~r|^{(.*)}$|, input)
  end

  def group_count(input) do
    case group?(input) do
      [_, group] ->
        count_group(group, 1)
      nil -> 0
    end
  end

  def group_score(input) do
    group_score(input, 0, 0)
  end

  def group_score(input, level, count) do
    case Regex.run(~r|^{([^,]*)}$|, input) do
      [_, group] ->
        group_score(group, level + 1, count + level * 1)
      nil ->
        case Regex.run(~r|^{(.*)}$|, input) do
          [_, groups] ->
            groups
            |> String.split(",", trim: true)
            |> Enum.map(&(group_score(&1, level, count + level)))
            |> IO.inspect(label: "level, count")
            |> Enum.sum()
            |> Kernel.+(level + 1)
          nil ->
            level + count
        end
    end
  end

  defp count_group([head | tail], acc) do
    acc = acc + group_count(head)
    count_group(tail, acc)
  end

  defp count_group(group, acc) do
    groups =
      group
      |> String.split(",", trim: true)
    acc + Enum.sum(Enum.map(groups, &group_count/1))
  end
end
