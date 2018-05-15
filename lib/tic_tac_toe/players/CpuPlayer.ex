defmodule TicTacToe.CpuPlayer do
  alias TicTacToe.{PlayerBehaviour, MinMax, Game, Coordinate}
  @behaviour PlayerBehaviour

  @spec get_move(%Game{}) ::
    {:ok, %Coordinate{}} | {:error, any()}

  def get_move(%Game{board: board, rules: rules}) do
    case rules.state do
      :player1_turn -> MinMax.get_move(board, :x)

      :player2_turn -> MinMax.get_move(board, :o)

      _otherwise -> {:error, "invalid Rules state for #{__MODULE__}"}
    end
  end
end
