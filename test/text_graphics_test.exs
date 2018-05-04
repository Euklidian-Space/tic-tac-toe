defmodule TicTacToe.TextGraphicsTest do
  use ExUnit.Case
  import TicTacToe.TestHelpers
  alias TicTacToe.{TextGraphics, Board}

  describe "tic tac toe board" do
    # test "should return a tic tac toe board as a string with no points drawn" do
    #   {:ok, board} = Board.new 3
    #   board_string = TextGraphics.draw_board(board)
    #   assert board_string ==
    #   "               |               |               \n               |               |               \n      +-+      |      +-+      |      +-+      \n      |1|      |      |2|      |      |3|      \n      +-+      |      +-+      |      +-+      \n               |               |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |               |               \n      +-+      |      +-+      |      +-+      \n      |4|      |      |5|      |      |6|      \n      +-+      |      +-+      |      +-+      \n               |               |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |               |               \n      +-+      |      +-+      |      +-+      \n      |7|      |      |8|      |      |9|      \n      +-+      |      +-+      |      +-+      \n               |               |               \n               |               |               \n               |               |               \n"
    # end
    #
    # test "should return a tic tac toe box with two xs in (1,1) and (1,2) and one o in (3,3)" do
    #   board = %{
    #     x_coords: [coord(1,1), coord(2,2)],
    #     o_coords: [coord(3,3)]
    #   } |> create_board()
    #
    #   board_string = TextGraphics.draw_board(board)
    #
    #   assert board_string ==
    #   "               |               |               \n   x       x   |               |               \n     x   x     |      +-+      |      +-+      \n       x       |      |2|      |      |3|      \n     x   x     |      +-+      |      +-+      \n   x       x   |               |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |   x       x   |               \n      +-+      |     x   x     |      +-+      \n      |4|      |       x       |      |6|      \n      +-+      |     x   x     |      +-+      \n               |   x       x   |               \n               |               |               \n_______________|_______________|_______________\n               |               |               \n               |               |    o o o o    \n      +-+      |      +-+      |   o       o   \n      |7|      |      |8|      |  o         o  \n      +-+      |      +-+      |   o       o   \n               |               |    o o o o    \n               |               |               \n               |               |               \n"
    # end
  end
end
