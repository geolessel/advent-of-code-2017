defmodule KnotHash do
  @input "106,118,236,1,130,0,235,254,59,205,2,87,129,25,255,118"
  @suffix [17, 31, 73, 47, 23]

  use Bitwise

  def run(step, input \\ @input) do
    run(step, input)
  end

  def run(:step1, input) do
    step1(
      starting_map(),
      String.split(input, ",", trim: true) |> Enum.map(&String.to_integer/1)
      )
  end

  def run(:step2, input) do
    step2(
      starting_map(),
      input
      )
  end
  
  def step1(list, lengths) do
    hash = run_hash(list, lengths, 0, 0)
    # IO.inspect(hash, label: "hash")
    Map.fetch!(hash, 0) * Map.fetch!(hash, 1)
  end

  def step2(list, lengths) do
    lengths =
      lengths
      |> convert_to_ascii()
      |> Enum.concat(@suffix)
      # |> IO.inspect(label: "list")

    {sparse, pos, skip} = 
      Enum.reduce(0..63, {list, 0, 0}, fn _i, {list, pos, skip} ->
        # IO.inspect({pos, skip}, label: "pos, skip, list")
        run_hash(list, lengths, pos, skip, :step2)
      end)

    dense =
      sparse
      |> Enum.sort_by(fn {key, _val} -> key end)
      |> Enum.map(fn {_key, val} -> val end)
      # |> IO.inspect(label: "dense")
      |> Enum.chunk_every(16)
      |> Enum.map(fn value ->
        Enum.reduce(value, 0, fn i, acc ->
          # IO.inspect({i, acc}, label: "i, acc")
          bxor(acc, i)
        end)
      end)

    dense
    |> Enum.map(&( Integer.to_string(&1, 16) ))
    # |> IO.inspect(label: "string")
    |> Enum.map(&( if byte_size(&1) < 2, do: "0#{&1}", else: &1 ))
    |> Enum.join()
  end


  def run_hash(list, [], _current_position, _skip), do: list
  def run_hash(list, [length | tail], current_position, skip) do
    count = Enum.count(list)
    new_position = wrap(count, current_position + length + skip)
    
    run_hash(
      reverse_length(list, length, current_position),
      tail,
      wrap(count, current_position + length + skip),
      skip + 1
      )
  end
  def run_hash(list, [],      pos, skip, :step2), do: {list, pos, skip}
  def run_hash(list, [length | tail], pos, skip, :step2) do
    count = Enum.count(list)
    new_position = wrap(count, pos + length + skip)
    # IO.inspect({length, pos, skip, new_position}, label: "length, pos, skip, new_position, tail")

    {new_list, new_new_position, new_skip} =
      run_hash(
        reverse_length(list, length, pos),
        tail,
        new_position,
        skip + 1,
        :step2
      )

    # Agent.update(__MODULE__, fn _ -> %{position: new_position, new_skip: new_skip} end)
    # IO.inspect(Agent.get(__MODULE__, &(&1)), label: "state")
    # 
    # {
    #   new_list,
    #   new_position,
    #   new_skip
    # }
  end

  def wrap(length, amount) do
    if amount >= length, do: rem(amount, length), else: amount
  end

  def reverse_length(list, length, position) do
    count = Enum.count(list)

    indices =
      0..length-1
      |> Enum.map(&(&1 + position))
      |> Enum.map(fn i -> if i >= count, do: i - count , else: i end)
      # |> IO.inspect(label: "indices")

    reversed = 
      indices
      |> Enum.map(fn i -> Map.get(list, i) end)
      |> Enum.reverse()
      # |> IO.inspect(label: "reversed")

    zipped =
      indices
      |> Enum.zip(reversed)
      # |> IO.inspect(label: "reversed zipped with indices")
      |> Enum.into(%{})
    Map.merge(list, zipped)
  end

  def convert_to_ascii(string) when is_binary(string) and byte_size(string) > 1 do
    String.split(string, "", trim: true) |> convert_to_ascii()
  end
  def convert_to_ascii(list) when is_list(list) do
    Enum.map(list, &convert_to_ascii/1)
  end
  def convert_to_ascii(character) when is_integer(character) do
    convert_to_ascii Integer.to_string(character)
  end
  def convert_to_ascii(character) when is_binary(character) and byte_size(character) == 1 do
    <<ascii::utf8>> = character
    ascii
  end
  def convert_to_ascii(""), do: []

  def starting_map do
    0..255
    |> Enum.into(%{}, &( {&1, &1} ))
  end
end
