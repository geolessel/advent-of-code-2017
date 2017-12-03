defmodule SpiralMemory do
  @input 347991
  @steps 250

  def steps(location \\ @input) do
    trunc(
      steps_to_center(:hor, location) +
      steps_to_center(:ver, location)
    )
    |> IO.inspect(label: "distance to center")
  end

  def part2 do
    row = 0
    col = 0
    
    %{{row, col} => 1}
    |> loop({row, col+1}, :e, 1)
    |> Map.values()
    |> Enum.sort()
    |> Enum.find(&(&1 > @input))
    |> IO.inspect(label: "first value larger than the puzzle input")
  end

  def loop(grid, _c, _d, step) when step >= @steps, do: grid
  def loop(grid, coords, direction, step) do
    grid = Map.put_new(grid, coords, surrounding_values(grid, coords))
    next_step(
      grid,
      coords,
      direction,
      step)
  end

  def next_step(grid, {row, col}, :e, step) do
    cond do
      value_absent?(grid, {row-1, col}) ->
        loop(grid, {row-1, col}, :n, step+1)
      true ->
        loop(grid, {row, col+1}, :e, step+1)
    end
  end

  def next_step(grid, {row, col}, :n, step) do
    cond do
      value_absent?(grid, {row, col-1}) ->
        loop(grid, {row, col-1}, :w, step+1)
      true ->
        loop(grid, {row-1, col}, :n, step+1)
    end
  end

  def next_step(grid, {row, col}, :w, step) do
    cond do
      value_absent?(grid, {row+1, col}) ->
        loop(grid, {row+1, col}, :s, step+1)
      true ->
        loop(grid, {row, col-1}, :w, step+1)
    end
  end

  def next_step(grid, {row, col}, :s, step) do
    cond do
      value_absent?(grid, {row, col+1}) ->
        loop(grid, {row, col+1}, :e, step+1)
      true ->
        loop(grid, {row+1, col}, :s, step+1)
    end
  end

  def add_value(grid, number, {x, y}) do
    Map.put_new(grid, {x, y}, number)
  end

  def value_present?(grid, {x, y}) do
    Map.has_key?(grid, {x, y})
  end

  def value_absent?(grid, coords) do
    !value_present?(grid, coords)
  end

  def surrounding_values(grid, {row, col}) do
    Map.get(grid, {row-1, col-1}, 0)   +
      Map.get(grid, {row-1, col}, 0)   +
      Map.get(grid, {row-1, col+1}, 0) +
      Map.get(grid, {row, col-1}, 0)   +
      Map.get(grid, {row, col+1}, 0)   +
      Map.get(grid, {row+1, col-1}, 0) +
      Map.get(grid, {row+1, col}, 0)   +
      Map.get(grid, {row+1, col+1}, 0)
  end

  def general_location(number) do
    closest_sq = Math.pow(closest_sqrt(number), 2)
    side_length = closest_sqrt(number) - 1

    se = closest_sq
    sw = closest_sq - side_length
    nw = closest_sq - (side_length * 2)
    ne = closest_sq - (side_length * 3)

    cond do
      number == se -> :se
      number == sw -> :sw
      number == nw -> :nw
      number == ne -> :ne
      number < se && number > sw -> :s
      number < sw && number > nw -> :w
      number < nw && number > ne -> :n
      number < ne -> :e
    end
  end

  def steps_to_center(:hor, number) do
    case general_location(number) do
      :e -> side_length(number) / 2
      :ne -> side_length(number) / 2
      :n -> abs(number - centers(number)[:n])
      :nw -> side_length(number) / 2
      :w -> side_length(number) / 2
      :sw -> side_length(number) / 2
      :s -> abs(number - centers(number)[:s])
      :se -> side_length(number) / 2
    end
  end

  def steps_to_center(:ver, number) do
    case general_location(number) do
      :e -> abs(number - centers(number)[:e])
      :ne -> side_length(number) / 2
      :n -> side_length(number) / 2
      :nw -> side_length(number) / 2
      :w -> abs(number - centers(number)[:w])
      :sw -> side_length(number) / 2
      :s -> side_length(number) / 2
      :se -> side_length(number) / 2
    end
  end

  def centers(number) do
    number = closest_sq(number)
    south_center = trunc(number - side_length(number) / 2)
    %{
      n: south_center - side_length(number) * 2,
      s: south_center,
      e: south_center - side_length(number) * 3,
      w: south_center - side_length(number)
    }
  end

  def closest_sq(number), do: Math.pow(closest_sqrt(number), 2)

  def side_length(number), do: closest_sqrt(number) - 1

  def closest_sqrt(number) do
    i = trunc(Float.ceil(Math.sqrt(number)))
    cond do
      rem(i, 2) == 0 -> i + 1
      true -> i
    end
  end
end
