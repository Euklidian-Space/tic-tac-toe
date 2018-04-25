defmodule TicTacToe.IOMock do
  alias TicTacToe.IOMock
  @enforce_keys [:gets_calls, :puts_calls]
  defstruct [:gets_calls, :puts_calls]

  def start_link do
    Agent.start_link(fn ->
      {:ok, %IOMock{} = state} = new()
      state
    end, name: __MODULE__)
  end

  def gets(message) do
  end

  def puts(message) do
    message
  end

  defp new() do
    {:ok, %IOMock{gets_calls: [], puts_calls: []}}
  end
end
