defmodule XMarkerTest do
  use ExUnit.Case, async: true
  import TicTacToe.TestHelpers
  alias TicTacToe.TextGraphics.XMarker

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
      assert {:ok, n_board_string} = XMarker.place_marks(centers, board)

      row4 = String.split(n_board_string, "\n")
      |> Stream.filter(&(&1 != ""))
      |> Enum.at(3)

      row11 = String.split(n_board_string, "\n")
      |> Stream.filter(&(&1 != ""))
      |> Enum.at(10)

      col8 = 7
      col38 = 37
      col42 = 41

      assert String.at(row4, col8) == "x"
      assert String.at(row11, col38) == "x"
      assert String.at(row11, col42) == "x"
    end

    test "should give error if mark drawing is off the board",
    %{blank_board: board}
    do
      centers = [{1, 1}]

      expected_err_msg =
        "XMarker off board. Perhaps one of the given centers: #{inspect centers} is invalid?"

      assert {:error, ^expected_err_msg}
        = XMarker.place_marks(centers, board)
    end
  end


end
