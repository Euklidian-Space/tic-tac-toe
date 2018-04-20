defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, Rules}
  import TicTacToe.TestHelpers

  setup  do
    {:ok, agent} = Game.start()
    {:ok, %{game_agent: agent}}
  end

  describe "start/0" do
    test "should start an agent with correct state", %{game_agent: agent} do
      assert is_pid(agent)
      assert %{
        board: %Board{},
        rules: %Rules{} = rules
      } = get_state(agent)

      assert rules.state == :initialized
    end

    test "should start a process named Game" do
      assert is_pid(Game)
      assert %{
        board: %Board{},
        rules: %Rules{} = rules
      } = get_state(Game)

      assert rules.state == :initialized
    end
  end

  describe "start_game/0" do
    test "should return tuple {:ok, pid}", %{game_agent: game_pid} do
      assert { :ok, %Game{rules: sm}, received_pid } = Game.start_game(game_pid)
      assert is_pid(received_pid)
      assert received_pid == game_pid
      assert sm.state == :player1_turn
    end
  end

  describe "place_mark/3" do
    setup %{game_agent: agent} do
      Game.start_game(agent)
      {:ok, %Game{} = game_state, _pid} = Game.place_mark(agent, 1, 2)
      {:ok, %{game_state: game_state}}
    end

    test "should return the game board and update game state",
    %{game_state: %Game{board: board, rules: rules}}
    do
      assert MapSet.member?(board.x, coord(1, 2))
      assert rules.state == :player2_turn
    end

    test "if mark is a win, then rules state should be :game_over" do
      agent = create_winable_game()
      assert {:ok, %Game{rules: sm}, _game_pid} = Game.place_mark(agent, 3, 3)
      assert sm.state == :game_over
    end

    test "if given coordinates are invalid should return error tuple",
    %{game_agent: agent}
    do
      assert {:error, :invalid_coordinate} = Game.place_mark(agent, 10, 1)
    end

    test "should alternate between player1_turn and player2_turn if not a winning mark",
    %{game_agent: pid}
    do
      assert {:ok, %Game{rules: sm}, _} = Game.place_mark(pid, 1, 1)
      assert sm.state == :player1_turn

      assert {:ok, %Game{rules: sm, board: board}, _} = Game.place_mark(pid, 3, 3)
      assert sm.state == :player2_turn

      assert %Board{x: xs, o: os} = board

      assert MapSet.member?(xs, coord(3,3))
      assert MapSet.member?(os, coord(1,1))
    end
  end

  defp get_state(agent), do: Agent.get(agent, &(&1))

  defp create_winable_game do
    board = %{
      o_coords: [coord(1,1), coord(1,2)],
      x_coords: [coord(3,1), coord(3,2)]
    } |> create_board
    sm = %Rules{state: :player1_turn}
    {:ok, game} = Agent.start_link(fn -> %Game{board: board, rules: sm} end)
    game
  end

end
