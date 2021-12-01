defmodule HexGrid do
  @input File.read!("input.txt") |> String.trim()

  def step1(input \\ @input) do
    input
    |> String.split(",", trim: true)
    |> move({0, 0, 0})
    |> distance()
  end

  def step2(input \\ @input) do
    {_final_location, max_distance} =
      input
      |> String.split(",", trim: true)
      |> Enum.reduce({{0,0,0}, 0}, fn step, {loc, max} ->
        new_loc = move(step, loc)
        {new_loc, new_max(distance(new_loc), max)}
      end)
    max_distance
  end

  def move([], loc), do: loc
  def move([head | tail], loc), do: move(tail, move(head, loc))
  def move("ne", {x, y, z}), do: {x + 1, y,     z - 1}
  def move("n",  {x, y, z}), do: {x,     y + 1, z - 1}
  def move("nw", {x, y, z}), do: {x - 1, y + 1, z    }
  def move("sw", {x, y, z}), do: {x - 1, y    , z + 1}
  def move("s",  {x, y, z}), do: {x    , y - 1, z + 1}
  def move("se", {x, y, z}), do: {x + 1, y - 1, z    }

  def distance({x, y, z}) do
    div(abs(x) + abs(y) + abs(z), 2)
  end

  def new_max(maybe, max) when maybe > max, do: maybe
  def new_max(_maybe, max), do: max
end
