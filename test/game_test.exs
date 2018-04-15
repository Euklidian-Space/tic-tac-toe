defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, GameStateM, winning_sets}

  describe "start_link/0" do
    test "should start an agent with correct state" do
      assert {:ok, game_pid} = Game.start_link()
      assert %Game{
        board: %Board{} = received_board,
        winning_sets: received_winning_sets,
        game_state: %GameStateM{} = received_game_state
      } = Agent.get(game_pid, fn state -> state end)

    end
  end
end
