defmodule BoardTest do
  use ExUnit.Case
  alias TicTacToe.{ Board, Coordinate }
  @board_size 3

  describe "new/1" do
    test "should return new game board" do
      expected_coordinates = available_coordinates()
      assert %Board{x: %MapSet{}, o: %MapSet{}, avail: received_coordinates} = Board.new(@board_size)
      assert received_coordinates == expected_coordinates
    end
  end

  def available_coordinates do
    coord = fn r, c ->
      {:ok, coord} = Coordinate.new(r, c)
      coord
    end

    MapSet.new([coord.(1,1), coord.(1,2), coord.(1,3),
               coord.(2,1), coord.(2,2), coord.(2,3),
               coord.(3,1), coord.(3,2), coord.(3,3)])
  end
end
