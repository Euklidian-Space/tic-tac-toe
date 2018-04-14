defmodule TicTacToe.WinningSets do
  alias TicTacToe.Coordinate

  def build(board_length) do
    diagnal_sets(board_length)
    ++ horizontal_sets(board_length)
    ++ vertical_sets(board_length)
    |> Enum.map(&MapSet.new/1)
  end

  defp diagnal_sets(diagnal_length) do
    [(for i <- 1..diagnal_length, do: coordinate(i, i))]
    ++
    [(for i <- 1..diagnal_length, do: coordinate(i, diagnal_length - i + 1))]
  end

  defp horizontal_sets(horizontal_length) do
    rows = cols = 1..horizontal_length
    for r <- rows, do: for c <- cols, do: coordinate(r, c)
  end

  defp vertical_sets(vertical_length) do
    rows = cols = 1..vertical_length
    for c <- cols, do: for r <- rows, do: coordinate(r, c)
  end

  defp coordinate(r, c) do
    {:ok, coord} = Coordinate.new(r, c)
    coord
  end
end
