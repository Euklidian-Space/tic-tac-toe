defmodule TicTacToe.TextGraphics.MarkerBehaviour do
  @callback place_marks(String.t(), [{non_neg_integer(), non_neg_integer()}])
    :: {:ok, String.t()} 
end
