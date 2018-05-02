defmodule BoardTest do
  use ExUnit.Case
  alias TicTacToe.{ Board, Coordinate }

  describe "new/1" do
    test "should return new game board" do
      expected_coordinates = available_coordinates()
      assert {
        :ok,
        %Board{
          x: %MapSet{},
          o: %MapSet{},
          avail: received_coordinates,
          winning_sets: _,
          size: 3
        }
      } = Board.new(3)
      assert received_coordinates == expected_coordinates
    end
  end

  describe "place_mark/3" do
    setup  do
      {:ok, board} = Board.new 3
      {:ok, %{board: board}}
    end

    test "placing an 'x' mark should update the x MapSet", %{board: board} do
      coordinate = coord(1, 1)
      expected = MapSet.new([coordinate])
      {:ok, _, %Board{x: received}} = Board.place_mark(board, :x, coordinate)
      assert expected == received
    end

    test "placing an 'o' mark should update the o MapSet", %{board: board} do
      coordinate = coord(1, 1)
      expected = MapSet.new([coordinate])
      {:ok, _, %Board{o: received}} = Board.place_mark(board, :o, coordinate)
      assert expected == received
    end

    test "marking a tile should remove said tile from the avail MapSet", %{board: board} do
      marked_tile = coord(1, 1)
      {:ok, _, %Board{avail: available_tiles}} = Board.place_mark(board, :x, marked_tile)
      refute MapSet.member?(available_tiles, marked_tile)

      {:ok, _, %Board{avail: available_tiles}} = Board.place_mark(board, :o, marked_tile)
      refute MapSet.member?(available_tiles, marked_tile)
    end

    test "should return an error tuple if tile is not available", %{board: board} do
      taken_tile = coord(1, 1)
      board = %Board{board | avail: MapSet.delete(board.avail, taken_tile)}
      assert {:error, reason} = Board.place_mark(board, :x, taken_tile)
      assert reason == "tile already taken."

      assert {:error, reason} = Board.place_mark(board, :o, taken_tile)
      assert reason == "tile already taken."
    end

    test "should return :no_win as the seconed element in tuple when mark is not a win", %{board: board} do
      assert {_, :no_win, _} = Board.place_mark(board, :o, coord(3,2))
    end

    test "should return win tuple if mark is a winning mark", %{board: board} do
      xwin_board = %Board{board | x: MapSet.new([coord(1,1), coord(1,2)])}
      assert {:ok, :win, _} = Board.place_mark(xwin_board, :x, coord(1, 3))

      owin_board = %Board{board | o: MapSet.new([coord(1,1), coord(1,2)])}
      assert {:ok, :win, _} = Board.place_mark(owin_board, :o, coord(1, 3))
    end

    test "should return :tie if mark is a tie", %{board: board} do
      os = MapSet.new([coord(1, 1), coord(2, 3), coord(3, 1), coord(3, 2)])
      xs = MapSet.new([coord(1, 2), coord(1, 3), coord(2, 1), coord(2, 2)])
      avail = MapSet.new([coord(3, 3)])
      board = %Board{board | o: os, x: xs, avail: avail}
      assert {:ok, :tie, _} = Board.place_mark(board, :x, coord(3, 3))
    end
  end

  def available_coordinates do
    MapSet.new([coord(1,1), coord(1,2), coord(1,3),
               coord(2,1), coord(2,2), coord(2,3),
               coord(3,1), coord(3,2), coord(3,3)])
  end

  def coord(r, c) do
    {:ok, coord} = Coordinate.new r, c
    coord
  end
end
