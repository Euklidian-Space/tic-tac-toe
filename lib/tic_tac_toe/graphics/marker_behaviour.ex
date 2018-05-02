defmodule TicTacToe.TextGraphics.MarkerBehaviour do
  @callback get_points(%TicTacToe.Board{}, {non_neg_integer(), non_neg_integer()}) ::
    [{non_neg_integer(), non_neg_integer()}]
end
