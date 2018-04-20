defmodule TicTacToe.Rules do
  alias __MODULE__
  defstruct state: :initialized

  def new, do: %Rules{}

  def check(%Rules{state: :initialized} = state, :add_player), do:
    {:ok, %Rules{state | state: :player1_turn}}

  # def check(%Rules{state: :initialized} = state, :add_cpu_player), do:
  #   {:ok, %Rules{state | state: :cpu1_turn}}

  def check(%Rules{state: :player1_turn} = state, {:mark, :player1}), do:
    {:ok, %Rules{state | state: :player2_turn}}

  def check(%Rules{state: :player2_turn} = state, {:mark, :player2}), do:
    {:ok, %Rules{state | state: :player1_turn}}

  def check(%Rules{state: :player1_turn} = state, {:chk_win, :win}), do:
    {:ok, %Rules{state | state: :game_over}}

  def check(%Rules{state: :player1_turn} = state, {:chk_win, :no_win}), do:
    {:ok, state}

  def check(%Rules{state: :player2_turn} = state, {:chk_win, :win}), do:
    {:ok, %Rules{state | state: :game_over}}

  def check(%Rules{state: :player2_turn} = state, {:chk_win, :no_win}), do:
    {:ok, state}


  def check(_state, _action), do: :error
end
