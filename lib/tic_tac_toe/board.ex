defmodule TicTacToe.Board do
  alias TicTacToe.{ Coordinate, Board }
  @enforce_keys [:x, :o, :avail ]
  defstruct [:x, :o, :avail]

  def new(board_size) do
    available_coordinates = add_coordinates(board_size)
    %Board{x: MapSet.new, o: MapSet.new, avail: available_coordinates}
  end

  defp add_coordinates(board_size) do
    rows = 1..board_size
    Enum.reduce_while(rows, MapSet.new, fn row, acc ->
      case add_column(row, board_size, acc) do
        {:ok, row_set} -> {:cont, row_set}
        {:error, _} = error -> {:halt, error}
      end
    end)
  end

  defp add_column(_, 0, map_set), do: {:ok, map_set}
  defp add_column(row, size, map_set) do
    case add_coordinate(row, size - row + 1, map_set) do
      {:ok, new_map_set} -> add_column(row, size - 1, new_map_set)
      {:error, _} = err -> err
    end
  end

  defp add_coordinate(r, c, map_set) do
    case Coordinate.new(r, c) do
      {:ok, coord} -> {:ok, MapSet.put(map_set, coord)}
      {:error, :invalid_coordinate} = error -> error
    end
  end
end
