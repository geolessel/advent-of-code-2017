Code.require_file "hex_grid.exs"
ExUnit.start

defmodule HexGridTest do
  use ExUnit.Case, async: true

  test ".move({0, 0, 0}, ne) returns {1, 0, -1}" do
    assert HexGrid.move("ne", {0, 0, 0}) == {1, 0, -1}
  end

  test ".move n returns {x, y + 1, z - 1}" do
    assert HexGrid.move("n", {0, 0, 0}) == {0, 1, -1}
  end

  test ".move s returns {x, y - 1, z + 1}" do
    assert HexGrid.move("s", {0, 0, 0}) == {0, -1, 1}
  end

  test ".move nw returns {x - 1, y + 1, z}" do
    assert HexGrid.move("nw", {0, 0, 0}) == {-1, 1, 0}
  end

  test ".move ne returns {x + 1, y, z - 1}" do
    assert HexGrid.move("ne", {0, 0, 0}) == {1, 0, -1}
  end

  test ".move se returns {x + 1, y - 1, z}" do
    assert HexGrid.move("se", {0, 0, 0}) == {1, -1, 0}
  end

  test ".move({0, 0, 0}, [ne, ne, ne]) returns {3, -3, 0}" do
    assert HexGrid.move(["ne", "ne", "ne"], {0, 0, 0}) == {3, 0, -3}
  end

  test ".move ne,ne,sw,sw goes back to the start" do
    assert HexGrid.move(["ne", "ne", "sw", "sw"], {0, 0, 0}) == {0, 0, 0}
  end

  test ".distance({3, 0, -3}) is 3" do
    assert HexGrid.distance({3, 0, -3}) == 3
  end

  test ".step1(ne,ne,s,s) is 2" do
    assert HexGrid.step1("ne,ne,s,s") == 2
  end
end
