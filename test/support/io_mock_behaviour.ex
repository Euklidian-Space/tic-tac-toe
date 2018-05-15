defmodule TicTacToe.IOMockBehaviour do
  # @behaviour TicTacToe.GameBehaviour
  @callback puts(String.t()) :: :ok
  @callback gets(String.t()) :: String.t()
end
