defmodule TicTacToe.TextGraphics.LabelBehaviour do
  alias TicTacToe.Coordinate

  @callback place_labels(
    String.t(),
    non_neg_integer(),
    [{%Coordinate{}, {non_neg_integer(), non_neg_integer()}}]
  ) :: {:ok, String.t()}

end
