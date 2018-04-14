defmodule CoordinateTest do
  use ExUnit.Case
  alias TicTacToe.Coordinate

  describe "new/2" do
    test "should return tuple with a coordinate struct" do
      assert {:ok, %Coordinate{row: r, col: c}} = Coordinate.new(1, 2)
      assert [r, c] == [1, 2]
    end

    test "should return an erro tuple for a coordinate that is out of range" do
      assert {:error, :invalid_coordinate} == Coordinate.new(0, 4)
      assert {:error, :invalid_coordinate} == Coordinate.new(1, 4)
      assert {:error, :invalid_coordinate} == Coordinate.new(0, 3)
    end
  end
end
