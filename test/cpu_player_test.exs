defmodule CpuPlayerTest do
  use ExUnit.Case, async: true
  import TicTacToe.TestHelpers
  alias TicTacToe.{CpuPlayer, Board, Rules, Game}

  describe "get_move/1" do
    setup do
      %{o_coords: [coord(1, 1)], x_coords: [coord(2,2), coord(3,3)]}
      |> create_board()
      |> (fn board ->
        game = %Game{board: board, rules: %Rules{state: :player1_turn}}
        { :ok, game: game }
      end).()
    end

    test "should return coordinate",
    %{game: game}
    do
      %Board{avail: avail} = game.board
      assert {:ok, coord} = CpuPlayer.get_move(game)
      assert MapSet.member?(avail, coord)
    end

    test "should return error tuple if rules state is not player1_turn nor player2_turn",
    %{game: game}
    do
      game = %Game{game | rules: %Rules{state: :some_other_state}}
      expected_msg = "invalid Rules state for #{CpuPlayer}"
      assert {:error, received_msg} = CpuPlayer.get_move(game)
      assert received_msg == expected_msg
    end

  end
end
