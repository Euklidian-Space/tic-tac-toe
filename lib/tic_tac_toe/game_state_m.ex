defmodule TicTacToe.GameStateM do
  alias __MODULE__
  defstruct state: :initialized

  def new, do: %GameStateM{}

  def check(%GameStateM{state: :initialized} = game_state, :add_player), do:
    {:ok, %GameStateM{game_state | state: :player1_turn}}

  def check(%GameStateM{state: :initialized} = game_state, :add_cpu_player), do:
    {:ok, %GameStateM{game_state | state: :cpu1_turn}}

  def check(%GameStateM{state: :player1_turn} = game_state, {:mark, :player1}), do:
    {:ok, %GameStateM{game_state | state: :player2_turn}}

  def check(%GameStateM{state: :player2_turn} = game_state, {:mark, :player2}), do:
    {:ok, %GameStateM{game_state | state: :player1_turn}}

  def check(%GameStateM{state: :player1_turn} = game_state, {:chk_win, :win}), do:
    {:ok, %GameStateM{game_state | state: :game_over}}

  def check(%GameStateM{state: :player1_turn} = game_state, {:chk_win, :no_win}), do:
    {:ok, game_state}

  def check(%GameStateM{state: :player2_turn} = game_state, {:chk_win, :win}), do:
    {:ok, %GameStateM{game_state | state: :game_over}}

  def check(%GameStateM{state: :player2_turn} = game_state, {:chk_win, :no_win}), do:
    {:ok, game_state}


  def check(_state, _action), do: :error
end
