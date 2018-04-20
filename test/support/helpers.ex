defmodule TicTacToe.TestHelpers do
  alias TicTacToe.{Board, Coordinate}

  def create_board(%{o_coords: os, x_coords: xs}) do
    {:ok, board} = Board.new
    board = Enum.reduce(os, board, fn coord, b ->
      {:ok, _, n_board} = Board.place_mark(b, :o, coord)
      n_board
    end)
    Enum.reduce(xs, board, fn coord, b ->
      {:ok, _, n_board} = Board.place_mark(b, :x, coord)
      n_board
    end)
  end

  def coord(r, c) do
    {:ok, coord} = Coordinate.new r, c
    coord
  end
end
