defmodule TicTacToe.Application do
  @moduledoc false
  use Application
  # import Supervisor.Spec
  alias TicTacToe.Game

  def start(_type, _args) do
    # children = [
    #   worker(Game, [name: Game])
    # ]
    #
    # opts = [strategy: :one_for_one, name: TicTacToe.Supervisor]
    # Supervisor.start_link(children, opts)
    Game.start
  end
end
