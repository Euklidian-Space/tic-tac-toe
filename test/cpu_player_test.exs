defmodule CpuPlayerTest do
  use ExUnit.Case
  alias TicTacToe.{CpuPlayer, Coordinate}
  import TicTacToe.TestHelpers

  describe "get_move/1" do
    test "should block potential win scenario 1" do
      board = %{
        o_coords: [coord(1,3), coord(3,3)],
        x_coords: [coord(1,1), coord(2,2)]
      }
      |> create_board

      assert {:ok, %Coordinate{row: r, col: c}} = CpuPlayer.get_move(board, :x)
      assert {r, c} == {2, 3}
    end

    test "should block potential win scenario 2" do
      board = %{
        x_coords: [coord(1, 1)],
        o_coords: []
      } |> create_board()

      assert {:ok, %Coordinate{row: r, col: c}} = CpuPlayer.get_move(board, :o)
      assert {r, c} == {2, 2}
    end

    test "exploratory test" do
      board = %{
        x_coords: [coord(1, 3)],
        o_coords: []
      } |> create_board()
      assert CpuPlayer.get_move(board, :o)
    end

    test "should take a win" do
      board = %{
        o_coords: [coord(1,1), coord(3,1)],
        x_coords: [coord(3,3), coord(2,2)]
      }
      |> create_board

      assert {:ok, %Coordinate{row: r, col: c}} = CpuPlayer.get_move(board, :o)
      assert {r, c} == {2, 1}
    end

    test "should avoid a potential trap" do
      board = %{
        o_coords: [coord(2,1)],
        x_coords: [coord(1,2), coord(3,3)]
      }
      |> create_board

      assert {:ok, %Coordinate{row: r, col: c}} = CpuPlayer.get_move(board, :o)
      refute {r, c} in [{1,3}, {2,3}]
    end

  end
end
