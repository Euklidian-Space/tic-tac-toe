defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, GameStateM, WinningSets}

  describe "start_link/0" do
    setup  do
      {:ok, %{game_agent: Game.start_link(3)}}
    end
    test "should start an agent with correct state" do
      {:ok, expected_board} = Board.new(3)
      expected_state_m = GameStateM.new()
      expected_winning_sets = WinningSets.build(3)
      assert {:ok, game_pid} = Game.start_link(3)
      assert %Game{
        board: %Board{} = received_board,
        winning_sets: received_winning_sets,
        state_machine: %GameStateM{} = received_state_m
      } = Agent.get(game_pid, fn state -> state end)

      assert expected_board == received_board
      assert expected_state_m == received_state_m
      assert expected_winning_sets == received_winning_sets
    end

    test "" do

    end
  end
end
