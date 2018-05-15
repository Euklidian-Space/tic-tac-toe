defmodule TicTacToe.DefaultPlayerTest do
  use ExUnit.Case, async: true
  alias TicTacToe.{DefaultPlayer, Game, Rules}
  import TicTacToe.TestHelpers
  import ExUnit.CaptureIO

  describe "get_move/2" do
    setup do
      %{o_coords: [coord(1, 1)], x_coords: [coord(2,2), coord(3,3)]}
      |> create_board()
      |> (fn board ->
        game = %Game{board: board, rules: %Rules{state: :player1_turn}}
        fun = fn ->
          move = DefaultPlayer.get_move(game)
          send self(), move
        end
        { :ok, game: game, capture_func: fun }
      end).()
    end

    test "should capture user input and return Coordinate struct",
    %{capture_func: fun}
    do
      input_coord_pairs = [
        {"1", coord(1,1)},
        {"2", coord(1,2)},
        {"3", coord(1,3)},
        {"4", coord(2,1)},
        {"5", coord(2,2)},
        {"6", coord(2,3)},
        {"7", coord(3,1)},
        {"8", coord(3,2)},
        {"9", coord(3,3)}
      ]

      for {input, expected_coord} <- input_coord_pairs do
        assert capture_io(input, fun) == "\n> "
        assert_received {:ok, received_coord}
        assert received_coord == expected_coord
      end
    end

    test "should return error tuple for invalid input",
    %{capture_func: fun}
    do
      assert capture_io("10", fun) == "\n> "
      assert_received {:error, "invalid input"}
    end
  end
end
