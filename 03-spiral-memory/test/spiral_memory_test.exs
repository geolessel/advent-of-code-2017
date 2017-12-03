defmodule SpiralMemoryTest do
  use ExUnit.Case
  doctest SpiralMemory

  test "can determine southeast corner" do
    assert SpiralMemory.general_location(9) == :se
    assert SpiralMemory.general_location(25) == :se
    assert SpiralMemory.general_location(49) == :se
  end

  test "can determine southwest corner" do
    assert SpiralMemory.general_location(7) == :sw
    assert SpiralMemory.general_location(21) == :sw
    assert SpiralMemory.general_location(43) == :sw
  end

  test "can determine northwest corner" do
    assert SpiralMemory.general_location(5) == :nw
    assert SpiralMemory.general_location(17) == :nw
    assert SpiralMemory.general_location(37) == :nw
  end

  test "can determine northeast corner" do
    assert SpiralMemory.general_location(3) == :ne
    assert SpiralMemory.general_location(13) == :ne
    assert SpiralMemory.general_location(31) == :ne
  end

  test "can determine south edge" do
    assert SpiralMemory.general_location(8) == :s
    assert SpiralMemory.general_location(22) == :s
  end

  test "can determine west edge" do
    assert SpiralMemory.general_location(6) == :w
    assert SpiralMemory.general_location(20) == :w
  end

  test "can determine north edge" do
    assert SpiralMemory.general_location(4) == :n
    assert SpiralMemory.general_location(16) == :n
  end

  test "can determine east edge" do
    assert SpiralMemory.general_location(2) == :e
    assert SpiralMemory.general_location(10) == :e
  end

  test "can determine how many steps to get to horizontal center" do
    assert SpiralMemory.steps_to_center(:hor, 2) == 1
    assert SpiralMemory.steps_to_center(:hor, 3) == 1
    assert SpiralMemory.steps_to_center(:hor, 4) == 0
    assert SpiralMemory.steps_to_center(:hor, 5) == 1
    assert SpiralMemory.steps_to_center(:hor, 6) == 1
    assert SpiralMemory.steps_to_center(:hor, 7) == 1
    assert SpiralMemory.steps_to_center(:hor, 8) == 0
    assert SpiralMemory.steps_to_center(:hor, 9) == 1
    assert SpiralMemory.steps_to_center(:hor, 25) == 2
    assert SpiralMemory.steps_to_center(:hor, 47) == 1
  end

  test "can determine steps to vertical center" do
    assert SpiralMemory.steps_to_center(:ver, 2) == 0
    assert SpiralMemory.steps_to_center(:ver, 3) == 1
    assert SpiralMemory.steps_to_center(:ver, 4) == 1
    assert SpiralMemory.steps_to_center(:ver, 5) == 1
    assert SpiralMemory.steps_to_center(:ver, 6) == 0
    assert SpiralMemory.steps_to_center(:ver, 7) == 1
    assert SpiralMemory.steps_to_center(:ver, 8) == 1
    assert SpiralMemory.steps_to_center(:ver, 9) == 1
    assert SpiralMemory.steps_to_center(:ver, 74) == 4
  end
end
