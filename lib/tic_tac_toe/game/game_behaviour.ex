defmodule TicTacToe.GameBehaviour do
  alias TicTacToe.{Board, Rules}

  @callback place_mark(pid(), {non_neg_integer(), non_neg_integer()}) ::
    {:ok, %{board: %Board{}, rules: %Rules{}, winner: atom()}}
    | {:error, any()}
end
