defmodule TicTacToe.Game do
  alias __MODULE__

  # defstruct [:board, :winning_sets, :game_state]
  defstruct board: nil, winning_sets: nil, game_state: nil

  def start_link do
    Agent.start_link(fn -> %Game{} end)
  end
end
