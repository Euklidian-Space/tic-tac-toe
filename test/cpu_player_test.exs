defmodule CpuPlayerTest do
  use ExUnit.Case
  alias TicTacToe.{CpuPlayer, Coordinate}
  import TicTacToe.TestHelpers

  describe "get_move/1" do
    test "should block potential win" do
      board = %{
        o_coords: [coord(1,3), coord(3,3)],
        x_coords: [coord(1,1), coord(2,2)]
      }
      |> create_winable_board

      assert {:ok, %Coordinate{row: r, col: c}} = CpuPlayer.get_move(board, :x)
      assert {r, c} == {2, 3}

      # assert {:ok, %Coordinate{row: r, col: c}} = CpuPlayer.get_move(board, :o)
      # assert {r, c} == {2, 3}
    end

    test "should prefer a trapping move scenario 1" do
      %{
        o_coords: [coord(1,2), coord(3,3)],
        x_coords: [coord(1,1), coord(2,2)]
      }
      |> create_winable_board
      |> CpuPlayer.get_move(:x)
      |> (fn {:ok, %Coordinate{row: r, col: c}} ->
        assert {r, c} in [{2, 1}, {3, 1}]
      end).()
    end

    test "should prefer a trapping move scenario 2" do
      %{
        o_coords: [coord(1, 2), coord(3, 1)],
        x_coords: [coord(2, 2), coord(1, 3)]
      }
      |> create_winable_board
      |> CpuPlayer.get_move(:x)
      |> (fn {:ok, %Coordinate{row: r, col: c}} ->
        assert {r, c} in [{2, 3}, {3,3}]
      end).()
    end
  end
end
