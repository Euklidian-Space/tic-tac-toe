defmodule TicTacToe.OMarkerTest do
  use ExUnit.Case, async: true
  import TicTacToe.TestHelpers
  alias TicTacToe.TextGraphics.OMarker

  describe "place_marks/2" do
    setup do
      rows = 8 * 3
      cols = 16 * 3
      blank_board = create_blank_board_string({rows, cols})
      {:ok, %{blank_board: blank_board}}
    end

    test "should return string with proper marks",
    %{blank_board: board}
    do
      centers = [{4, 8}, {12, 40}]
      assert {:ok, n_board_string} = OMarker.place_marks(board, centers)

      rows = String.split(n_board_string, "\n") |> Stream.filter(&(&1 != ""))
      row2 = Enum.at(rows, 1)
      row3 = Enum.at(rows, 2)
      row4 = Enum.at(rows, 3)

      [col3, col4, col5, col7, col9, col13] = [2, 3, 4, 6, 8,12]

      assert String.at(row2, col5) == "o"
      assert String.at(row2, col7) == "o"
      assert String.at(row2, col9) == "o"
      assert String.at(row3, col4) == "o"
      assert String.at(row4, col3) == "o"
      assert String.at(row4, col13) == "o"
    end

  end
end
