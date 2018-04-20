defmodule RulesTest do
  use ExUnit.Case
  alias TicTacToe.Rules

  describe "new/0" do
    test "should return a Rules struct" do
      assert %Rules{} = Rules.new
    end
  end

  describe "check/2" do
    setup  do
      {:ok, %{fresh_state: Rules.new}}
    end

    test "should change game state to :player1_turn", %{fresh_state: state} do
      assert {:ok, %Rules{state: :player1_turn}} = Rules.check(state, :add_player)
    end

    test ":add_player action should yield error if state was not in :initialized" do
      state = %Rules{state: :some_other_state}
      assert :error = Rules.check(state, :add_player)
    end

    # test "should change game state to :cpu1_turn", %{fresh_state: state} do
    #   assert {:ok, %Rules{state: :cpu1_turn}} = Rules.check(state , :add_cpu_player)
    # end
    #
    # test ":add_cpu_player action should yield :error if state was not in :initialized" do
    #   state = %Rules{state: :some_other_state}
    #   assert :error = Rules.check(state, :add_cpu_player)
    # end

    test "should return error on unrecognized action", %{fresh_state: state} do
      assert :error = Rules.check(state, :invalid_action)
    end

    test "should change game state to :player2_turn when player1 makes a mark that does not win" do
      state = %Rules{state: :player1_turn}
      assert {:ok, %Rules{state: :player2_turn}} = Rules.check(state, {:mark, :player1})
    end

    test "action {:mark, :player1} should yield error if state was not in :player1_turn" do
      state = %Rules{state: :player2_turn}
      assert :error = Rules.check(state, {:mark, :player1})
    end

    test "should change game state to :player1_turn when player2 makes a mark that does not win" do
      state = %Rules{state: :player2_turn}
      assert {:ok, %Rules{state: :player1_turn}} = Rules.check(state, {:mark, :player2})
    end

    test "action {:mark, :player2} should yield error if state was not in :player2_turn" do
      state = %Rules{state: :player1_turn}
      assert :error = Rules.check(state, {:mark, :player2})
    end

    test "action {:chk_win, has_won} should change state to :game_over if has_won is :win" do
      state = %Rules{state: :player1_turn}
      assert {:ok, %Rules{state: :game_over}} = Rules.check(state, {:chk_win, :win})

      state = %Rules{state: :player2_turn}
      assert {:ok, %Rules{state: :game_over}} = Rules.check(state, {:chk_win, :win})
    end

    test "action {:chk_win, has_won} should not change state if has_won is :no_win" do
      state = %Rules{state: :player1_turn}
      assert {:ok, %Rules{state: :player1_turn}} = Rules.check(state, {:chk_win, :no_win})

      state = %Rules{state: :player2_turn}
      assert {:ok, %Rules{state: :player2_turn}} = Rules.check(state, {:chk_win, :no_win})
    end
  end
end
