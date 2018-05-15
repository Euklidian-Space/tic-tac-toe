defmodule TicTacToe.GameBehaviour do
  alias TicTacToe.{Board, Rules}

  @callback place_mark(non_neg_integer(), non_neg_integer()) ::
    {:ok, %{board: %Board{}, rules: %Rules{}, winner: atom()}}
    | {:error, any()}
end
