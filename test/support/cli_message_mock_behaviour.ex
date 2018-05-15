defmodule TicTacToe.CliMessageMockBehaviour do
  @callback demo() :: any()
  @callback end_message(atom() | {atom(), atom()}) :: atom() | {atom(), atom()}
  @callback prompt_restart(atom(), (... -> any())) :: any()
  @callback welcome_msg() :: any()
end
