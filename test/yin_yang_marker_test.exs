defmodule TicTacToe.YinYangMarkerTest do
  use ExUnit.Case, async: true
  import TicTacToe.TestHelpers
  alias TicTacToe.TextGraphics.{YinYangMarker, Points}
  alias TicTacToe.Coordinate

  describe "place_marks/2" do
    setup do
      rows = 16
      cols = 32
      blank_board = create_blank_board_string({rows, cols})
      {:ok, %{blank_board: blank_board, rows: rows, cols: cols}}
    end

    test "should return string with proper marks",
    %{blank_board: board, rows: rs, cols: cs}
    do
      centers = [%Coordinate{row: 1, col: 1}]
      |> Enum.map(&(Points.get_square_center(&1, {rs, cs})))

      assert {:ok, n_board_string} = YinYangMarker.place_marks(board, centers)

      rows = String.split(n_board_string, "\n") |> Enum.filter(&(&1 != ""))

      Enum.at(rows, 4) |> String.contains?("_.----._") |> assert
      Enum.at(rows, 5) |> String.contains?(".'   /  _ '.") |> assert
      Enum.at(rows, 6) |> String.contains?("/    |  (_)  \\") |> assert
      Enum.at(rows, 7) |> String.contains?("|     \\        |") |> assert
      Enum.at(rows, 8) |> String.contains?("|      '.      |") |> assert
      Enum.at(rows, 9) |> String.contains?("|    _   `\\    |") |> assert
      Enum.at(rows, 10) |> String.contains?("\\  (_)   |   /") |> assert
      Enum.at(rows, 11) |> String.contains?("'._    / _.'") |> assert
      Enum.at(rows, 12) |> String.contains?("'----'") |> assert
    end
  end

  describe "preview/0" do
    test "should return a preview" do
      preview = YinYangMarker.preview()
      assert preview
    end
  end
end

#4 through 12

#     _.----._
#   .'   /  _ '.
#  /    |  (_)  \
# |     \        |
# |      '.      |
# |    _   `\    |
#  \  (_)   |   /
#   '._    / _.'
#      '----'
