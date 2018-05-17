use Mix.Config

config(:tic_tac_toe, :io, TicTacToe.IOMock)

config :tic_tac_toe, :markers,
  o: TicTacToe.TextGraphics.OMarker,
  x: TicTacToe.TextGraphics.XMarker
