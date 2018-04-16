defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game, WinningSets, GameStateM}
  
  defstruct board: nil, winning_sets: nil, state_machine: nil

  def new(board_size) do
    {:ok, board} = Board.new(board_size)
    {
      :ok,
      %Game{
        board: board,
        winning_sets: WinningSets.build(board_size),
        state_machine: GameStateM.new()
      }
    }
  end

  def start_link(board_size) do
    Agent.start_link(fn ->
      {:ok, game} = new(board_size)
      game
    end)
  end

end
