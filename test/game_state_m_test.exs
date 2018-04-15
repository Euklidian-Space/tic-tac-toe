defmodule GameStateMTest do
  use ExUnit.Case
  alias TicTacToe.GameStateM

  describe "new/0" do
    test "should return a GameStateM struct" do
      assert %GameStateM{} = GameStateM.new
    end
  end

  describe "check/2" do
    setup  do
      {:ok, %{fresh_state: GameStateM.new}}
    end

    test "should change game state to :player_ready", %{fresh_state: state} do
      assert %GameStateM{state: :player_ready} = GameStateM.check(state, :add_player)
    end

    test ":add_player action should yield error if state was not in :initialized" do
      game_state = %GameStateM{state: :some_other_state}
      assert :error = GameStateM.check(game_state, :add_player)
    end

    test "should change game state to :cpu_ready", %{fresh_state: state} do
      assert %GameStateM{state: :cpu_ready} = GameStateM.check(state , :add_cpu_player)
    end

    test ":add_cpu_player action should yield :error if state was not in :initialized" do
      game_state = %GameStateM{state: :some_other_state}
      assert :error = GameStateM.check(game_state, :add_cpu_player)
    end

    test "should return error on unrecognized action", %{fresh_state: state} do
      assert :error = GameStateM.check(state, :invalid_action)
    end
  end
end
