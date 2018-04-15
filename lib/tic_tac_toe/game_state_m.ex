defmodule TicTacToe.GameStateM do
  alias __MODULE__
  defstruct state: :initialized

  def new, do: %GameStateM{}

  def check(%GameStateM{state: :initialized} = game_state, :add_player), do:
    %GameStateM{game_state | state: :player_ready}

  def check(%GameStateM{state: :initialized} = game_state, :add_cpu_player), do:
    %GameStateM{game_state | state: :cpu_ready}

  def check(_state, _action), do: :error
end
