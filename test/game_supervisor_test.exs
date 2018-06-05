defmodule TicTacToe.GameSupervisorTest do 
  use ExUnit.Case
  alias TicTacToe.{GameSupervisor, Game}
  import TicTacToe.TestHelpers

  describe "on Application startup" do
    test "GameSupervisor should be available after startup" do 
      assert Process.whereis(GameSupervisor)  
    end 
  end

  describe "start_game/1" do 
    test "should start a game with given name" do 
      assert {:ok, game} = GameSupervisor.start_game("test")
      assert %Game{rules: rules} = :sys.get_state(game)
      assert rules.state == :initialized
      Process.exit(game, :shutdown)
    end 
  end 

  describe "stop_game/1" do 
    setup do 
      {:ok, game} = GameSupervisor.start_game("test")
      on_exit fn -> Process.exit(game, :shutdown) end
      {:ok, game: game}
    end 

    test "should terminate the game by the given name", 
    %{game: game} 
    do 
      via = Game.via_tuple("teset")
      assert :ok = GameSupervisor.stop_game("test")
      refute Process.alive?(game)
      refute GenServer.whereis(via)
    end 
  end 
end 
