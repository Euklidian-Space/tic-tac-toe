defmodule TicTacToe.TestHelpers do
  alias TicTacToe.{Board, Coordinate}

  def create_board(%{o_coords: os, x_coords: xs}) do
    {:ok, board} = Board.new 3
    board = Enum.reduce(os, board, fn coord, b ->
      {:ok, _, n_board} = Board.place_mark(b, :o, coord)
      n_board
    end)
    Enum.reduce(xs, board, fn coord, b ->
      {:ok, _, n_board} = Board.place_mark(b, :x, coord)
      n_board
    end)
  end

  def create_board(%{avail: avail}) do
    {:ok, board} = Board.new 3
    Enum.reduce(board.avail, {:x, board}, fn
      a, {:x, b } ->
        case MapSet.member?(avail, a) do
          false ->
            {:ok, _, n_board} = Board.place_mark(b, :x, a)
            {:o, n_board}

          _ ->
            {:o, b}
        end

      a, {:o, b} ->
        case MapSet.member?(avail, a) do
          false ->
            {:ok, _, n_board} = Board.place_mark(b, :o, a)
            {:x, n_board}

          _ ->
            {:x, b}
        end
    end)
    |> elem(1)
  end

  def create_board(:fresh, size) do
    {:ok, board} = Board.new(size)
    board
  end

  def coord(r, c) do
    {:ok, coord} = Coordinate.new r, c
    coord
  end

  def create_blank_board_string({rows, cols}) do
    Enum.reduce(1..rows, "", fn _, result ->
      result <> build_blank_board_row(cols)
    end)
  end

  defp build_blank_board_row(1), do: " \n"
  defp build_blank_board_row(cols), do:
    " " <> build_blank_board_row(cols - 1)
end
