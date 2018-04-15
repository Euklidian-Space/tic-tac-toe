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

    test "should change game state to :player1_turn", %{fresh_state: state} do
      assert {:ok, %GameStateM{state: :player1_turn}} = GameStateM.check(state, :add_player)
    end

    test ":add_player action should yield error if state was not in :initialized" do
      game_state = %GameStateM{state: :some_other_state}
      assert :error = GameStateM.check(game_state, :add_player)
    end

    test "should change game state to :cpu1_turn", %{fresh_state: state} do
      assert {:ok, %GameStateM{state: :cpu1_turn}} = GameStateM.check(state , :add_cpu_player)
    end

    test ":add_cpu_player action should yield :error if state was not in :initialized" do
      game_state = %GameStateM{state: :some_other_state}
      assert :error = GameStateM.check(game_state, :add_cpu_player)
    end

    test "should return error on unrecognized action", %{fresh_state: state} do
      assert :error = GameStateM.check(state, :invalid_action)
    end

    test "should change game state to :player2_turn when player1 makes a mark that does not win" do
      game_state = %GameStateM{state: :player1_turn}
      assert {:ok, %GameStateM{state: :player2_turn}} = GameStateM.check(game_state, {:mark, :player1})
    end

    test "action {:mark, :player1} should yield error if state was not in :player1_turn" do
      game_state = %GameStateM{state: :player2_turn}
      assert :error = GameStateM.check(game_state, {:mark, :player1})
    end

    test "should change game state to :player1_turn when player2 makes a mark that does not win" do
      game_state = %GameStateM{state: :player2_turn}
      assert {:ok, %GameStateM{state: :player1_turn}} = GameStateM.check(game_state, {:mark, :player2})
    end

    test "action {:mark, :player2} should yield error if state was not in :player2_turn" do
      game_state = %GameStateM{state: :player1_turn}
      assert :error = GameStateM.check(game_state, {:mark, :player2})
    end

    test "action {:chk_win, has_won} should change state to :game_over if has_won is :win" do
      game_state = %GameStateM{state: :player1_turn}
      assert {:ok, %GameStateM{state: :game_over}} = GameStateM.check(game_state, {:chk_win, :win})

      game_state = %GameStateM{state: :player2_turn}
      assert {:ok, %GameStateM{state: :game_over}} = GameStateM.check(game_state, {:chk_win, :win})
    end

    test "action {:chk_win, has_won} should not change state if has_won is :no_win" do
      game_state = %GameStateM{state: :player1_turn}
      assert {:ok, %GameStateM{state: :player1_turn}} = GameStateM.check(game_state, {:chk_win, :no_win})

      game_state = %GameStateM{state: :player2_turn}
      assert {:ok, %GameStateM{state: :player2_turn}} = GameStateM.check(game_state, {:chk_win, :no_win})
    end
  end
end
