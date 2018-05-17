defmodule TicTacToe.TextGraphicsTest do
  use ExUnit.Case
  import TicTacToe.TestHelpers
  alias TicTacToe.{TextGraphics, Board}
  alias TicTacToe.TextGraphics.{YinYangMarker, OMarker, XMarker, DefaultLabel}

  describe "tic tac toe board" do
    test "should return a tic tac toe board as a string with no points drawn" do
      {:ok, board} = Board.new 3
      markers = %{omarker: OMarker, xmarker: XMarker}
      assert {:ok, _board_string} = TextGraphics.draw_board(board, markers, DefaultLabel)
    end

    test "should return a tic tac toe box with two xs in (1,1) and (1,2) and one o in (3,3)" do
      board = %{
        x_coords: [coord(1,1), coord(2,2)],
        o_coords: [coord(3,3), coord(3,2)]
      } |> create_board()

      markers = %{omarker: YinYangMarker, xmarker: XMarker}
      assert {:ok, _board_string} = TextGraphics.draw_board(board, markers, DefaultLabel)
    end
  end
end


#     _.----._
#   .'   /    '.
#  /    |       \
# |     \        |
# |      '.      |
# |        `\    |
#  \        |   /
#   '._    / _.'
#      '----'
