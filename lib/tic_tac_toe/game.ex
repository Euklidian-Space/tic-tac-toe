defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game, GameStateM}

  defstruct board: nil, state_machine: nil

  def new() do
    {:ok, board} = Board.new()
    {
      :ok,
      %Game{
        board: board,
        state_machine: GameStateM.new()
      }
    }
  end

  def start_link() do
    Agent.start_link(fn ->
      {:ok, game} = new()
      game
    end)
  end

end
