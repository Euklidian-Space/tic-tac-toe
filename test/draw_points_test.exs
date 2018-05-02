defmodule TicTacToe.DrawPointsTest do
  use ExUnit.Case
  import TicTacToe.{TestHelpers}
  alias TicTacToe.TextGraphics.DrawPoints
  alias TicTacToe.Coordinate

  @square_dimensions {8, 16}

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

      %{x_points: received_points} = DrawPoints.get_points(board, @square_dimensions)

      assert(
        MapSet.new(received_points)
        |> MapSet.equal?(expected_points)
      )
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

      %{x_points: received_points} = DrawPoints.get_points(board, @square_dimensions)

      assert(
        MapSet.new(received_points)
        |> MapSet.equal?(expected_points)
      )
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

      %{o_points: received_points} = DrawPoints.get_points(board, @square_dimensions)

      assert(
        MapSet.new(received_points)
        |> MapSet.equal?(expected_points)
      )
    end

    test "should return list of tuples representing the draw points for square Labels" do
      squares = [{1,1}, {1,2}, {1,3}, {2,1}, {2,2}, {2,3}, {3,1}, {3,2}, {3,3}]
      Enum.map(squares, fn {r, c} ->
        %{avail: MapSet.new([coord(r, c)])}
        |> create_board()
      end)
      |> Enum.each(fn b ->
        expected_points = b.avail |> Enum.to_list |> List.first |> label_points_for
        %{label_points: received_points} = DrawPoints.get_points(b, @square_dimensions)

        assert expected_points == received_points
      end)
    end

    test "should return list of tuple for available square labels" do
      coords = [coord(1,1), coord(3,3)]
      board = %{avail: MapSet.new(coords)} |> create_board()
      expected_points = label_points_for(coord(3,3)) ++ label_points_for(coord(1,1))
        |> MapSet.new
      %{label_points: received_points} = DrawPoints.get_points(board, @square_dimensions)

      assert expected_points == MapSet.new(received_points)
    end
  end

  defp label_points_for(%Coordinate{row: 1, col: 1}), do:
    [{3,7}, {3,8}, {3,9}, {4,7}, {4,8}, {4,9}, {5,7}, {5,8}, {5,9}]

  defp label_points_for(%Coordinate{row: 1, col: 2}), do:
    [{3,23}, {3,24}, {3,25}, {4,23}, {4,24}, {4,25}, {5,23}, {5,24}, {5,25}]

  defp label_points_for(%Coordinate{row: 1, col: 3}), do:
    [{3,39}, {3,40}, {3,41}, {4,39}, {4,40}, {4,41}, {5,39}, {5,40}, {5,41}]

  defp label_points_for(%Coordinate{row: 2, col: 1}), do:
    [{11,7}, {11,8}, {11,9}, {12,7}, {12,8}, {12,9}, {13,7}, {13,8}, {13,9}]

  defp label_points_for(%Coordinate{row: 2, col: 2}), do:
    [{11,23}, {11,24}, {11,25}, {12,23}, {12,24}, {12,25}, {13,23}, {13,24}, {13,25}]

  defp label_points_for(%Coordinate{row: 2, col: 3}), do:
    [{11, 39}, {11,40}, {11,41}, {12,39}, {12,40}, {12,41}, {13,39}, {13, 40}, {13,41}]

  defp label_points_for(%Coordinate{row: 3, col: 1}), do:
    [{19,7}, {19,8}, {19,9}, {20,7}, {20,8}, {20,9}, {21,7}, {21,8}, {21,9}]

  defp label_points_for(%Coordinate{row: 3, col: 2}), do:
    [{19,23}, {19,24}, {19,25}, {20,23}, {20,24}, {20,25}, {21,23}, {21,24}, {21,25}]

  defp label_points_for(%Coordinate{row: 3, col: 3}), do:
    [{19,39}, {19,40}, {19,41}, {20,39}, {20,40}, {20,41}, {21,39}, {21,40}, {21,41}]
end


"""
  +-+
  |9|
  +-+
  +-+
  |8|
  +-+
  +-+
  |7|
  +-+
  +-+
  |6|
  +-+
  +-+
  |5|
  +-+
  +-+
  |4|
  +-+
  +-+
  |3|
  +-+
  +-+
  |2|
  +-+
  +-+
  |1|
  +-+
"""
