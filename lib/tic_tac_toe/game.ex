defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game, GameStateM, Coordinate}

  defstruct board: nil, state_machine: nil

  def start_link() do
    Agent.start_link(fn ->
      {:ok, game} = new()
      game
    end)
  end

  def start_game(game) when is_pid(game) do
    Agent.get_and_update(game, fn %Game{state_machine: sm} = state ->
      {:ok, state_machine} = GameStateM.check(sm, :add_player)
      new_state = %Game{state | state_machine: state_machine}
      { {:ok, game}, new_state }
    end)
  end

  # def place_mark(x, y) when is_integer(x) and is_integer(y) do
  #
  # end

  defp new() do
    {:ok, board} = Board.new()
    {
      :ok,
      %Game{
        board: board,
        state_machine: GameStateM.new()
      }
    }
  end

end
