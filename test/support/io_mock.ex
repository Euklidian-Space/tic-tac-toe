defmodule TicTacToe.IOMock do
  @behaviour TicTacToe.IOMockBehaviour

  def puts(_data) do
    :ok
  end

  def gets(_data) do
    "ok"
  end
end
