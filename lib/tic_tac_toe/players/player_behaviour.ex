defmodule TicTacToe.PlayerBehaviour do
  alias TicTacToe.{Game, Coordinate}

  @callback get_move(%Game{}) ::
    { :ok, %Coordinate{} } | {:error, any()}
end
