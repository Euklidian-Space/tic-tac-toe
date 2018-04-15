defmodule TicTacToe.Board do
  alias TicTacToe.{ Coordinate, Board }
  @enforce_keys [:x, :o, :avail ]
  @size 3
  defstruct [:x, :o, :avail]

  def new(board_size) when board_size != @size, do:
    {:error, "invalid board size"}

  def new(board_size) do
    available_coordinates = add_coordinates(board_size)
    {:ok, %Board{x: MapSet.new, o: MapSet.new, avail: available_coordinates}}
  end

  def place_mark(board, :x, %Coordinate{} = coord) do
    case coord_taken?(board, coord) do
      true -> {:error, "tile already taken."}
      false ->
        board = %Board{board | x: MapSet.put(board.x, coord), avail: MapSet.delete(board.avail, coord)}
        {:ok, chk_win(board, :x), board}
    end
  end

  def place_mark(board, :o, %Coordinate{} = coord) do
    case coord_taken?(board, coord) do
      true -> {:error, "tile already taken."}
      false ->
        board = %Board{board | o: MapSet.put(board.o, coord), avail: MapSet.delete(board.avail, coord)}
        {:ok, chk_win(board, :o), board}
    end
  end

  defp add_coordinates(board_size) do
    rows = 1..board_size
    Enum.reduce(rows, MapSet.new, fn row, acc ->
      {:ok, row_set} = add_column(row, board_size, acc)
      row_set
    end)
  end

  defp add_column(_, 0, map_set), do: {:ok, map_set}
  defp add_column(row, size, map_set) do
    {:ok, new_map_set} = add_coordinate(row, size, map_set)
    add_column(row, size - 1, new_map_set)
  end

  defp add_coordinate(r, c, map_set) do
    {:ok, coord} = Coordinate.new(r, c)
    {:ok, MapSet.put(map_set, coord)}
  end

  defp coord_taken?(board, coord), do:
    not MapSet.member?(board.avail, coord)

  defp chk_win(board, :x) do
    Enum.any?(winning_sets(), fn winning_set ->
      MapSet.subset?(winning_set, board.x)
    end)
    |> win?
  end

  defp chk_win(board, :o) do
    Enum.any?(winning_sets(), fn winning_set ->
      MapSet.subset?(winning_set, board.o)
    end)
    |> win?
  end

  defp win?(true), do: :win
  defp win?(false), do: :no_win

  defp winning_sets do
    TicTacToe.WinningSets.build(@size)
  end

end
