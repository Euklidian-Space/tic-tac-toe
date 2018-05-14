defmodule TicTacToe.DefaultLabelTest do
  use ExUnit.Case, async: true
  import TicTacToe.TestHelpers
  alias TicTacToe.TextGraphics.{DefaultLabel, Points}
  alias TicTacToe.Coordinate

  describe "place_labels/3" do
    setup do
      rows = 16
      cols = 32
      blank_board = create_blank_board_string({rows * 3, cols * 3})
      {:ok, %{blank_board: blank_board, rows: rows, cols: cols}}
    end

    test "should return string with proper labels",
    %{blank_board: board, rows: rs, cols: cs}
    do
      centers = [%Coordinate{row: 1, col: 1}, %Coordinate{row: 3, col: 2}]
      |> Enum.map(fn coord ->
        {coord, Points.get_square_center(coord, {rs, cs})}
      end)

      assert {:ok, n_board_string} = DefaultLabel.place_labels(board, 3, centers)

      rows = String.split(n_board_string, "\n") |> Enum.filter(&(&1 != ""))

      [row7, row8, row9] = Enum.map(7..9, fn row ->
        Enum.at(rows, row)
      end)

      [row39, row40, row41] = Enum.map(39..41, fn row ->
        Enum.at(rows, row)
      end)

      String.contains?(row7, "+-+")
      |> assert("+-+ is not contained in #{row7}")

      String.contains?(row8, "|1|")
      |> assert("|1| is not contained in #{row8}")

      assert String.at(row8, 15) == "1"

      String.contains?(row9, "+-+")
      |> assert("+-+ is not contained in #{row9}")

      String.contains?(row39, "+-+")
      |> assert("+-+ is not contained in #{row39}")

      String.contains?(row40, "|8|")
      |> assert("|8| is not contained in #{row40}")

      String.contains?(row41, "+-+")
      |> assert("+-+ is not contained in #{row41}")
    end
  end
end

# 7 through 9
#39 through 41

# +--+
# |19|
# +--+
