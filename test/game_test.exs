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
      assert { :ok, %Game{state_machine: sm}, received_pid } = Game.start_game(game_pid)
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
    %{game_state: %Game{board: board, state_machine: state_machine}}
    do
      assert MapSet.member?(board.x, coord(1, 2))
      assert state_machine.state == :player2_turn
    end

    test "if mark is a win, then state_machine state should be :game_over" do
      agent = create_winable_game()
      assert {:ok, %Game{state_machine: sm}, _game_pid} = Game.place_mark(agent, 3, 1)
      assert sm.state == :game_over
    end

    test "if given coordinates are invalid should return error tuple",
    %{game_agent: agent}
    do
      assert {:error, :invalid_coordinate} = Game.place_mark(agent, 10, 1)
    end

    test "if called when state machine is :player2_turn should return error tuple",
    %{game_agent: ga}
    do
      assert {:error, "The turn belongs to player 2."} = Game.place_mark(ga, 1, 1)
    end
  end

  defp get_state(agent), do: Agent.get(agent, &(&1))

  defp coord(x, y) do
    {:ok, coord} = Coordinate.new(x, y)
    coord
  end

  defp create_winable_game do
    coords = [coord(1,1), coord(2,1)]
    {:ok, board} = Board.new
    board = Enum.reduce(coords, board, fn coord, b ->
      %Board{b | x: MapSet.put(b.x, coord)}
    end)
    sm = %GameStateM{state: :player1_turn}
    {:ok, game} = Agent.start_link(fn -> %Game{board: board, state_machine: sm} end)
    game
  end

end
