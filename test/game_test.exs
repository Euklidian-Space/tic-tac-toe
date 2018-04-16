defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, GameStateM}

  describe "start_link/0" do
    setup  do
      {:ok, %{game_agent: Game.start_link()}}
    end
    test "should start an agent with correct state" do
      {:ok, expected_board} = Board.new()
      expected_state_m = GameStateM.new()
      assert {:ok, game_pid} = Game.start_link(3)
      assert %Game{
        board: %Board{} = received_board,
        state_machine: %GameStateM{} = received_state_m
      } = Agent.get(game_pid, fn state -> state end)

      assert expected_board == received_board
      assert expected_state_m == received_state_m
    end

    # test "" do
    #
    # end
  end
end
