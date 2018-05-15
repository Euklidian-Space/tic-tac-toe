defmodule TicTacToe.CliMessageMock do
  @behaviour TicTacToe.CliMessageMockBehaviour

  def demo() do
    :not_implemented
  end

  def end_message(_) do
    :not_implemented
  end

  def prompt_restart(_, _) do
    :not_implemented
  end

  def welcome_msg() do
    :not_implemented
  end
end
