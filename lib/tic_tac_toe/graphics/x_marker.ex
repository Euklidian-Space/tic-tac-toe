defmodule TicTacToe.TextGraphics.XMarker do
  alias TicTacToe.Board
  alias TicTacToe.TextGraphics.MarkerBehaviour

  @behaviour MarkerBehaviour

  def get_points(%Board{} = board, {})
end
