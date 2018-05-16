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
      assert {:ok, n_board_string} = XMarker.place_marks(board, centers)

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

  end

  describe "preview/0" do
    test "should return a preview" do
      preview = XMarker.preview()
      assert preview
    end
  end

end
