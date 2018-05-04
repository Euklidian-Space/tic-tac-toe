defmodule TicTacToe.TextGraphics.MarkerBehaviour do
  @doc """
  The tuples in the list of the first argument represent cells on the game board
  string of the second argument.  The rows and columns that each cell occupies
  are 1-indexed.
  """
  @callback place_marks([{non_neg_integer(), non_neg_integer()}], String.t())
    :: {:ok, String.t()} | {:error, String.t()}
end
