defmodule WinningSetsTest do
  use ExUnit.Case
  alias TicTacToe.{ WinningSets, Coordinate }

  describe "build/0" do
    test "should return list of MapSets" do
      received = MapSet.new WinningSets.build(3)
      expected = MapSet.new winning_sets
      assert received == expected
    end
  end

  def winning_sets do
    coordinate = fn r, c ->
      {:ok, coord} = Coordinate.new(r, c)
      coord
    end
    [
      MapSet.new([coordinate.(1, 1), coordinate.(1, 2), coordinate.(1, 3)]),
      MapSet.new([coordinate.(2, 1), coordinate.(2, 2), coordinate.(2, 3)]),
      MapSet.new([coordinate.(3, 1), coordinate.(3, 2), coordinate.(3, 3)]),
      MapSet.new([coordinate.(1, 1), coordinate.(2, 1), coordinate.(3, 1)]),
      MapSet.new([coordinate.(1, 2), coordinate.(2, 2), coordinate.(3, 2)]),
      MapSet.new([coordinate.(1, 3), coordinate.(2, 3), coordinate.(3, 3)]),
      MapSet.new([coordinate.(1, 1), coordinate.(2, 2), coordinate.(3, 3)]),
      MapSet.new([coordinate.(3, 1), coordinate.(2, 2), coordinate.(1, 3)])
    ]
  end
end
