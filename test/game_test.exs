defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, GameStateM}

  setup  do
    {:ok, agent} = Game.start_link()
    {:ok, %{game_agent: agent}}
  end

  describe "start_link/0" do
    test "should start an agent with correct state", %{game_agent: agent} do
      assert is_pid(agent)
      assert %{
        board: %Board{},
        state_machine: %GameStateM{} = state_machine
      } = get_state(agent)

      assert state_machine.state == :initialized
    end
  end

  describe "start_game/0" do
    test "should return tuple {:ok, pid}", %{game_agent: game_pid} do
      assert { :ok, received_pid } = Game.start_game(game_pid)
      assert is_pid(received_pid)
      assert received_pid == game_pid
      %Game{state_machine: %GameStateM{state: state}} = get_state(received_pid)
      assert state == :player1_turn
    end
  end

  # describe "place_mark/2" do
  #   setup %{game_agent: agent} do
  #     {:ok, %Board{} = board} = Game.place_mark(1, 2)
  #   end
  #
  #   test "should return the game board and update game state" do
  #
  #   end
  # end

  defp get_state(agent), do: Agent.get(agent, &(&1))

end
