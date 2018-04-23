defmodule TicTacToe.DrawPointsTest do
  use ExUnit.Case
  import TicTacToe.TestHelpers
  alias TicTacToe.TextGraphics.DrawPoints

  describe "get_points/2" do
    test "should return a list of tuples representing the draw points for x in box (1, 1)" do
      board = %{
        x_coords: [coord(1, 1)],
        o_coords: []
      } |> create_board()

      expected_points = [
        {2, 4}, {3, 6}, {4, 8}, {5, 10}, {6, 12},
        {2, 12}, {3, 10}, {5, 6}, {6, 4}
      ] |> MapSet.new

      received_points = DrawPoints.get_points(board, :x) |> MapSet.new

      assert MapSet.equal?(expected_points, received_points)
    end

    test "should return a list of tuples representing the draw points for x in box (3,2)" do
      board = %{
        x_coords: [coord(3,2)],
        o_coords: []
      } |> create_board()

      expected_points = [
        {18, 20}, {19, 22}, {20, 24}, {21, 26}, {22, 28},
        {22, 20}, {21, 22}, {19, 26}, {18, 28}
      ] |> MapSet.new

      received_points = DrawPoints.get_points(board, :x) |> MapSet.new

      assert MapSet.equal?(expected_points, received_points)
    end

    test "should return a list of tuples representing the draw points for o in box (3,2)" do
      board = %{
        o_coords: [coord(3, 3)],
        x_coords: []
      } |> create_board()

      expected_points = [
        {20, 35}, {19, 36}, {18, 37}, {18, 39}, {18, 41}, {18, 43}, {19, 44},
        {20, 45}, {21, 36}, {22, 37}, {22, 39}, {22, 41}, {22, 43}, {21, 44}
      ] |> MapSet.new

      received_points = DrawPoints.get_points(board, :o) |> MapSet.new

      assert MapSet.equal?(expected_points, received_points)
    end
  end
end
