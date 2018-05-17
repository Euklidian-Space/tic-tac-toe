use Mix.Config

config :tic_tac_toe, :markers,
  yinyang: TicTacToe.TextGraphics.YinYangMarker,
  cat: TicTacToe.TextGraphics.CatMarker,
  x: TicTacToe.TextGraphics.XMarker,
  o: TicTacToe.TextGraphics.OMarker
