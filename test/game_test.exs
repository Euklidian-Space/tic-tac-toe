defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, GameStateM, Coordinate}

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

  describe "place_mark/3" do
    setup %{game_agent: agent} do
      Game.start_game(agent)
      {:ok, %Board{} = board, _pid} = Game.place_mark(agent, 1, 2)
      {:ok, %{board: board}}
    end

    test "should return the game board and update game state", %{game_agent: agent, board: board} do
      assert MapSet.member?(board.x, coord(1, 2))
      %Game{state_machine: %GameStateM{state: state}} = get_state(agent)
      assert state == :player2_turn
    end
  end

  defp get_state(agent), do: Agent.get(agent, &(&1))

  defp coord(x, y) do
    {:ok, coord} = Coordinate.new(x, y)
    coord
  end

end
