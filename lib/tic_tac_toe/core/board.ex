defmodule TicTacToe.Board do
  alias TicTacToe.{ Coordinate, Board, WinningSets }
  @enforce_keys [:x, :o, :avail, :winning_sets, :size]
  # @size 3
  defstruct [:x, :o, :avail, :winning_sets, :size]


  def new(size \\ 3) when is_integer(size) and size >= 1 do
    available_coordinates = add_coordinates(size)
    {
      :ok,
      %Board{
        x: MapSet.new,
        o: MapSet.new,
        avail: available_coordinates,
        winning_sets: WinningSets.build(size),
        size: size
      }
    }
  end

  def place_mark(board, :x, %Coordinate{} = coord) do
    case coord_taken?(board, coord) do
      true -> {:error, "tile already taken."}
      false ->
        board = %Board{board | x: MapSet.put(board.x, coord), avail: MapSet.delete(board.avail, coord)}
        {:ok, chk_win_tie(board, :x), board}
    end
  end

  def place_mark(board, :o, %Coordinate{} = coord) do
    case coord_taken?(board, coord) do
      true -> {:error, "tile already taken."}
      false ->
        board = %Board{board | o: MapSet.put(board.o, coord), avail: MapSet.delete(board.avail, coord)}
        {:ok, chk_win_tie(board, :o), board}
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

  defp chk_win_tie(board, :x) do
    case chk_win(board, :x) do
      :no_win -> chk_tie(board)
      win -> win
    end
  end

  defp chk_win_tie(board, :o) do
    case chk_win(board, :o) do
      :no_win -> chk_tie(board)
      win -> win
    end
  end

  defp chk_win(board, :x) do
    Enum.any?(board.winning_sets, fn winning_set ->
      MapSet.subset?(winning_set, board.x)
    end)
    |> win?
  end

  defp chk_win(board, :o) do
    Enum.any?(board.winning_sets, fn winning_set ->
      MapSet.subset?(winning_set, board.o)
    end)
    |> win?
  end

  defp chk_tie(board) do
    Enum.empty?(board.avail)
    |> case  do
      true -> :tie
      _ -> :no_win
    end
  end

  defp win?(true), do: :win
  defp win?(false), do: :no_win


end
