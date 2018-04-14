defmodule BoardTest do
  use ExUnit.Case
  alias TicTacToe.{ Board, Coordinate }
  @board_size 3

  describe "new/1" do
    test "should return new game board" do
      expected_coordinates = available_coordinates()
      assert {:ok, %Board{x: %MapSet{}, o: %MapSet{}, avail: received_coordinates}} = Board.new(@board_size)
      assert received_coordinates == expected_coordinates
    end

    test "should return an error tuple if board size is out of range" do
      assert {:error, message} = Board.new(4)
      assert message == "invalid board size"
      assert {:error, message} = Board.new(0)
      assert message == "invalid board size"
    end
  end

  # describe "place_mark/3" do
  #   setup  do
  #     board = Board.new(3)
  #     {:ok %{board: board}}
  #   end
  #
  #   test "placing a mark x mark should update the x MapSet" do
  #   end
  # end

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
