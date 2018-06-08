defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board}
  import TicTacToe.TestHelpers

  describe "start_link/2" do
    test "should return {:ok, pid}" do
      assert {:ok, game} = Game.start_link("some name")
      assert is_pid(game)
    end

    test "should initialize state as a Game struct" do
      assert {:ok, game} = Game.start_link("some name")
      assert %Game{name: received_name, rules: received_rules} = :sys.get_state(game)
      assert received_name == "some name"
      assert received_rules.state == :initialized
    end

    test "start_link/2 should save game name to :game_state ets table"
    do 
      {:ok, game} = Game.start_link("ets test")
      expected_name = "ets test"
      expected_state_data = :sys.get_state(game)
      assert [{received_name, received_state_data}] = :ets.lookup(:game_state, "ets test")
      assert received_name == expected_name
      assert received_state_data == expected_state_data
    end 
  end

  describe "start_game/1" do
    setup do
      {:ok, game} = Game.start_link("game test")
      {:ok, game: game}
    end

    test "should return :ok and update rules state",
    %{game: game}
    do
      assert :ok = Game.start_game(game)
      assert %Game{rules: rules} = :sys.get_state(game)
      assert rules.state == :player1_turn
    end
  end

  describe "place_mark/3" do
    setup do
      {:ok, game} = Game.start_link("game test")
      :ok = Game.start_game(game)
      {:ok, game: game}
    end

    test "should return the game board and update game state",
    %{game: game}
    do
      {:ok, %Game{board: board, rules: rules}} = Game.place_mark(game, {1, 2})
      assert MapSet.member?(board.x, coord(1, 2))
      assert rules.state == :player2_turn
    end


    test "if given coordinates are invalid should return error tuple",
    %{game: game} do
      assert {:error, :invalid_coordinate} = Game.place_mark(game, {10, 1})
    end
    #
    test "should alternate between player1_turn and player2_turn if not a winning mark",
    %{game: game}
    do
      assert {:ok, %Game{rules: sm}} = Game.place_mark(game, {1, 1})
      assert sm.state == :player2_turn

      assert {:ok, %Game{rules: sm, board: board}} = Game.place_mark(game, {3, 3})
      assert sm.state == :player1_turn

      assert %Board{x: xs, o: os} = board

      assert MapSet.member?(os, coord(3,3))
      assert MapSet.member?(xs, coord(1,1))
    end

  end

  describe "handle_info {:set_state, name}" do 
    setup do 
      {:ok, name: "ets test", board_size: 3}
    end 

    test "should not overwrite ets table if an entry with name already exists",
    %{name: name, board_size: board_size} 
    do 
      expected_state = "some state"
      :ets.insert(:game_state, {name, expected_state})
      assert {:noreply, ^expected_state, _} = 
        Game.handle_info({:set_state, name, board_size}, "some other state")

      [{^name, received_state}] = :ets.lookup(:game_state, name)

      refute received_state == "some other state"
      assert received_state == expected_state
    end 
  end

  #describe "handle_call {:place_mark, {x, y}}" do 
  #  setup do 
  #    {:ok, game} = Game.start_link("game over test")  
  #    {:ok, state: create_winable_game(game, :sys.get_state(game))}
  #  end 
  #  
  #  test "" ,
  #  %{state: winable_game} 
  #  do 
  #    
  #  end 
  #end 

  describe "game over" do 
    setup do
      name = "game test"
      {:ok, game} = Game.start_link(name)
      :ok = Game.start_game(game)
      {:ok, game: game, name: name}
    end

    test "if mark is a win, then rules state should be :game_over and winner field should be populated",
    %{game: game} do
      create_winable_game(game, :sys.get_state(game))
      assert {:ok, %Game{rules: sm, winner: :player1}} = Game.place_mark(game, {3, 3})
      assert sm.state == :game_over
    end

    test "if mark is a tie, then rules should be :game_over and winner field should be nil",
    %{game: game}
    do
      create_tie_game(game, :sys.get_state(game))
      assert {:ok, %Game{rules: sm, winner: nil}} = Game.place_mark(game, {1, 2})
      assert sm.state == :game_over
    end
  end 

  describe "handle_info :timeout" do 
    test "should return {:stop, {:shutdown, :timeout}, state_data}" do 
      expected_data = "some data"
      assert {:stop, {:shutdown, :timeout}, ^expected_data} = 
        Game.handle_info(:timeout, "some data") 
    end 
  end 

  describe "terminate/2" do 
    setup do 
      name = "terminate test"
      {:ok, game} = Game.start_link(name)
      {:ok, state_data: :sys.get_state(game), name: name}
    end 

    test "should delete :game_state ets entry",
    %{state_data: state_data, name: name}
    do 
      assert :ok = Game.terminate({:shutdown, :timeout}, state_data)
      assert [] = :ets.lookup(:game_state, name)
    end 

    test "should return :ok for unrecognized input" do 
      assert :ok = 
        Game.terminate({:unrecognized_reason, :unrecognized_msg}, "some data")
    end 
  end 

  defp create_winable_game(game, game_state) do
    [{3, 1}, {1, 1}, {3, 2}, {1, 2}]
    |> Enum.reduce(game_state, fn mark, _state ->
      Game.place_mark(game, mark)
    end)
  end

  defp create_tie_game(game, state_data) do
    [{2, 2}, {3, 2}, {1, 3}, {3, 1}, {3, 3}, {1, 1}, {2, 1}, {2, 3}]
    |> Enum.reduce(state_data, fn mark, _state ->
      Game.place_mark(game, mark)
    end)
  end

end
