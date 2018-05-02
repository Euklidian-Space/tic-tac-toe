defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Board, Rules}
  import TicTacToe.TestHelpers


  describe "Game on startup" do
    test "application should start Game process with correct starting state"
    do
      assert %{
        board: %Board{},
        rules: %Rules{} = rules
      } = Agent.get(Game, fn state -> state end)

      assert rules.state == :initialized
    end
  end

  describe "place_mark/3" do
    setup  do
      {:ok, %Game{} = game_state} = Game.start_game()
      {:ok, game_state: game_state}
      on_exit(fn ->
        Game.reset_game(board_size: 3)
      end)
    end

    test "should return the game board and update game state"
    do
      {:ok, %Game{board: board, rules: rules}} = Game.place_mark(1, 2)
      assert MapSet.member?(board.x, coord(1, 2))
      assert rules.state == :player2_turn
    end
    
    test "if mark is a win, then rules state should be :game_over and winner field should be populated" do
      create_winable_game()
      assert {:ok, %Game{rules: sm, winner: :player1}} = Game.place_mark(3, 3)
      assert sm.state == :game_over
    end

    test "if given coordinates are invalid should return error tuple" do
      assert {:error, :invalid_coordinate} = Game.place_mark(10, 1)
    end

    test "should alternate between player1_turn and player2_turn if not a winning mark"
    do
      assert {:ok, %Game{rules: sm}} = Game.place_mark(1, 1)
      assert sm.state == :player2_turn

      assert {:ok, %Game{rules: sm, board: board}} = Game.place_mark(3, 3)
      assert sm.state == :player1_turn

      assert %Board{x: xs, o: os} = board

      assert MapSet.member?(os, coord(3,3))
      assert MapSet.member?(xs, coord(1,1))
    end

    test "if mark is a tie, then rules should be :game_over and winner field should be nil" do
      create_tie_game()
      assert {:ok, %Game{rules: sm, winner: nil}} = Game.place_mark(1, 2)
      assert sm.state == :game_over
    end
  end

  defp create_winable_game do
    Game.place_mark(3,1)
    Game.place_mark(1,1)
    Game.place_mark(3,2)
    Game.place_mark(1,2)
  end

  defp create_tie_game do
    [{2, 2}, {3, 2}, {1, 3}, {3, 1}, {3, 3}, {1, 1}, {2, 1}, {2, 3}]
    |> Enum.each(fn {r, c} ->
      Game.place_mark(r, c)
    end)
  end

end
