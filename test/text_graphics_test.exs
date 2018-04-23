defmodule TicTacToe.TextGraphicsTest do
  use ExUnit.Case
  import TicTacToe.TestHelpers
  alias TicTacToe.{TextGraphics, Board}

  describe "tic tac toe board" do
    test "should return a tic tac toe board as a string with no points drawn" do
      {:ok, board} = Board.new
      board_string = TextGraphics.draw_board(board)
      assert board_string ==
        "               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n               |               |               \n"
    end

    test "should return a tic tac toe box with two xs in (1,1) and (1,2) and one o in (3,3)" do
      board = %{
        x_coords: [coord(1,1), coord(2,2)],
        o_coords: [coord(3,3)]
      } |> create_board()

      board_string = TextGraphics.draw_board(board)

      assert board_string ==
        "               |               |               \n   x       x   |               |               \n     x   x     |               |               \n       x       |               |               \n     x   x     |               |               \n   x       x   |               |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |   x       x   |               \n               |     x   x     |               \n               |       x       |               \n               |     x   x     |               \n               |   x       x   |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |               |    o o o o    \n               |               |   o       o   \n               |               |  o         o  \n               |               |   o       o   \n               |               |    o o o o    \n               |               |               \n               |               |               \n"
    end
  end
end

# """
#   ii0 0 0 0
#   i0       0
#   0iiiiiiiii0
#    0       0
#     0 0 0 0
#
#     5 by 11
# """
# """
#   ii00 0 0
#   i0     0
#   0iiiiiii0
#    0     0
#     0 0 0
#
#     5 by 11
# """
#
# """
#       x       x
#         x   x
#           x
#         x   x
#       x       x
#
#       5 by 9
# """
