defmodule TicTacToe.PointsTest do
  use ExUnit.Case, async: true
  import TicTacToe.TestHelpers
  alias TicTacToe.TextGraphics.{Points}

  describe "get_square_center/1" do
    test "should return the center of given square" do
      expected = [
        {4,8}, {4,24}, {4,40},
        {12,8}, {12,24}, {12,40},
        {20,8}, {20,24}, {20,40}
      ]
      [{1,1}, {1,2}, {1,3}, {2,1}, {2,2}, {2,3}, {3,1}, {3,2}, {3,3}]
      |> Stream.map(fn {r, c} -> coord(r, c) end)
      |> Stream.map(fn coord ->
        Points.get_square_center(coord, {8, 16})
      end)
      |> Enum.each(fn tuple ->
        assert (tuple in expected)
      end)
    end
  end

  describe "get_square_tuple" do
    test "given a row col tuple return which square that tuple belongs to" do
      [{1,1}, {1,18}, {1, 39}, {10, 9}]
      |> Enum.map(fn tup ->
        {:ok, coord} = Points.get_square_coord(tup, {8, 16})
        coord
      end)
      |> MapSet.new
      |> MapSet.equal?(MapSet.new([coord(1,1), coord(1, 2), coord(1,3), coord(2,1)]))
      |> assert
    end
  end
end
