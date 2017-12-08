defmodule Register do
  @example File.stream!("example.txt", [], :line)
  @input File.stream!("input.txt", [], :line)

  def step1(instructions \\ @input) do
    instructions
    |> Stream.transform(%{}, fn instruction, acc ->
      {acc, process_instruction(instruction, acc)}
    end)
    |> Enum.into(%{})
    |> Enum.max_by(fn {key, val} -> val end)
    |> IO.inspect()
  end

  def step2(instructions \\ @input) do
    {_registry, max} =
      instructions
      |> Enum.reduce({%{}, 0}, fn instruction, {acc, max} ->
        IO.inspect(instruction, label: "instruction")
        process_instruction(instruction, acc, max)
      end)
    IO.inspect(max, label: "max")
  end

  def process_instruction(instruction, register) do
    {loc, instruction, amount, check_reg, check, check_amount} =
      split_instruction(instruction)

    {mod, fun} = string_to_function(check)

    apply(mod, fun, [Map.get(register, check_reg, 0), check_amount])
    |> modify_register(register, loc, instruction, amount)
  end
  def process_instruction(instruction, register, max_achieved) do
    {loc, instruction, amount, check_reg, check, check_amount} =
      split_instruction(instruction)

    {mod, fun} = string_to_function(check)

    apply(mod, fun, [Map.get(register, check_reg, 0), check_amount])
    |> modify_register(register, loc, instruction, amount, max_achieved)
  end

  defp string_to_function("<"),  do: {Kernel, :<}
  defp string_to_function("<="), do: {Kernel, :<=}
  defp string_to_function(">"),  do: {Kernel, :>}
  defp string_to_function(">="), do: {Kernel, :>=}
  defp string_to_function("=="), do: {Kernel, :==}
  defp string_to_function("!="), do: {Kernel, :!=}

  defp modify_register(false, register, _, _, _), do: register
  defp modify_register(true, register, loc, instruction, amount) do
    amount = if instruction == "inc", do: amount, else: amount * -1

    register
    |> Map.update(loc, amount, fn x -> x + amount end)
  end
  defp modify_register(false, register, _, _, _, max), do: {register, max}
  defp modify_register(true, register, loc, instruction, amount, max) do
    amount = if instruction == "inc", do: amount, else: amount * -1

    register = Map.update(register, loc, amount, fn x -> x + amount end)
    max = if register[loc] > max, do: register[loc], else: max
    {register, max}
  end

  defp split_instruction(instruction) do
    [loc, instruction, amount, "if", check_reg, check, check_amount] =
      instruction
      |> String.split(~r|\s+|, trim: true)
    amount = String.to_integer(amount)
    check_amount = String.to_integer(check_amount)
    {loc, instruction, amount, check_reg, check, check_amount}
  end
end
