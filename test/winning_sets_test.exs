defmodule WinningSetsTest do
  use ExUnit.Case
  alias TicTacToe.{ WinningSets, Coordinate }

  describe "build/0" do
    test "should return list of MapSets" do
      received = MapSet.new WinningSets.build(3)
      expected = MapSet.new winning_sets()
      assert received == expected
    end
  end

  def coord(r, c) do
    {:ok, coord} = Coordinate.new(r, c)
    coord
  end

  def winning_sets do
    [
      MapSet.new([coord(1, 1), coord(1, 2), coord(1, 3)]),
      MapSet.new([coord(2, 1), coord(2, 2), coord(2, 3)]),
      MapSet.new([coord(3, 1), coord(3, 2), coord(3, 3)]),
      MapSet.new([coord(1, 1), coord(2, 1), coord(3, 1)]),
      MapSet.new([coord(1, 2), coord(2, 2), coord(3, 2)]),
      MapSet.new([coord(1, 3), coord(2, 3), coord(3, 3)]),
      MapSet.new([coord(1, 1), coord(2, 2), coord(3, 3)]),
      MapSet.new([coord(3, 1), coord(2, 2), coord(1, 3)])
    ]
  end
end
