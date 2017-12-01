defmodule InverseCaptcha do
  use Application

  @input File.read!("lib/input.txt") |> String.trim()

  def start(_type, _args) do
    IO.puts("step 1: #{step1()}")
    IO.puts("step 2: #{step2()}")
    {:ok, self()}
  end

  @doc """
  The captcha requires you to review a sequence of digits
  (your puzzle input) and find the sum of all digits that
  match the next digit in the list. The list is circular,
  so the digit after the last digit is the first digit in
  the list.

  For example:

  1122 produces a sum of 3 (1 + 2)
    because the first digit (1) matches the second digit
    and the third digit (2) matches the fourth digit.
  1111 produces 4
    because each digit (all 1) matches the next.
  1234 produces 0
    because no digit matches the next.
  91212129 produces 9
    because the only digit that matches the next one is
    the last digit, 9.
  """
  def step1(string \\ @input) do
    string
    # add the beginning of the string to the end,
    # effectively wrapping the resulting list
    |> String.replace(~r/(.)(.*)/, "\\1\\2\\1")
    |> string_to_list()
    |> Enum.chunk_every(2, 1, discard: true)
    |> Enum.reduce(0, fn([a, b], acc) ->
      if a == b, do: acc + a, else: acc
    end)
  end

  @doc """
  Now, instead of considering the next digit, it wants you
  to consider the digit halfway around the circular list.
  That is, if your list contains 10 items, only include a
  digit in your sum if the digit 10/2 = 5 steps forward
  matches it. Fortunately, your list has an even number 
  of elements.

  For example:

  1212 produces 6
    the list contains 4 items, and all four digits match
    the digit 2 items ahead.
  1221 produces 0
    because every comparison is between a 1 and a 2.
  123425 produces 4
    because both 2s match each other, but no other digit
    has a match.
  123123 produces 12
  12131415 produces 4
  """

  def step2(string \\ @input) do
    list = string_to_list(string)
    jump = div(Enum.count(list), 2)
    
    list
    |> Enum.with_index()
    |> Enum.reduce(0, fn({x, i}, acc) ->
      if x == wrapped_at(list, i + jump), do: acc + x, else: acc
    end)
  end

  defp string_to_list(string) do
    string
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp wrapped_at(list, index) do
    count = Enum.count(list)
    index =
      case index >= count do
        true -> index - count
        false -> index
      end
    Enum.at(list, index)
  end
end
