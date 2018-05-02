defmodule TicTacToe.Application do
  @moduledoc false
  use Application
  alias TicTacToe.Game

  def start(_type, _args) do
    Game.start(board_size: 3)
  end
end
