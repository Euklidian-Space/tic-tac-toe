defmodule TicTacToe.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.Game},
      TicTacToe.GameSupervisor
    ]
    
    :ets.new(:game_state, [:public, :named_table])
    opts = [strategy: :one_for_one, name: TicTacToe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
