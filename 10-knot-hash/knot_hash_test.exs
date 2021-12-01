Code.require_file "knot_hash.exs"
ExUnit.start

defmodule KnotHashTest do
  use ExUnit.Case, async: true

  test ".run_hash(%{0,1,2,3,4}, [3], 0, 0) returns {%{2,1,0,3,4}, 3, 3, 1}" do
    assert KnotHash.run_hash(%{0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4}, [3], 0, 0) == %{0 => 2, 1 => 1, 2 => 0, 3 => 3, 4 => 4}
  end

  test ".reverse_length(%{0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4], 3, 0) returns %{0 => 2, 1 => 1, 2 => 0, 3 => 3, 4 => 4}" do
    map = 0..4 |> Enum.into(%{}, &( {&1, &1} ))
    assert KnotHash.reverse_length(map, 3, 0) == %{0 => 2, 1 => 1, 2 => 0, 3 => 3, 4 => 4}
  end

  test ".reverse_length(%{0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4], 3, 3) returns %{0 => 2, 1 => 1, 2 => 0, 3 => 3, 4 => 4}" do
    map = 0..4 |> Enum.into(%{}, &( {&1, &1} ))
    assert KnotHash.reverse_length(map, 3, 3) == %{0 => 3, 1 => 1, 2 => 2, 3 => 0, 4 => 4}
  end

  test ".step1([0,1,2,3,4], [3,4,1,5]) returns 12" do
    map = 0..4 |> Enum.into(%{}, &( {&1, &1} ))
    assert KnotHash.step1(map, [3,4]) == 12
  end
end
