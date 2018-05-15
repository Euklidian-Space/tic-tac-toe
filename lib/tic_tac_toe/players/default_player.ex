defmodule TicTacToe.DefaultPlayer do
  @behaviour TicTacToe.PlayerBehaviour
  alias TicTacToe.{Game, Coordinate}

  @spec get_move(%Game{}) ::
    { :ok, %Coordinate{} } | { :error, any() }

  def get_move(%Game{} = game) do
    %{size: size} = game.board
    number_of_squares = :math.pow(size, 2) |> trunc
    allowable_inputs = Enum.map(1..number_of_squares, &(Integer.to_string(&1)))

    input = IO.gets("\n> ")
    |> String.trim
    |> String.downcase

    with {:ok, parsed_input} <- translate_input(input, allowable_inputs),
         {r, c} <- do_get_move(parsed_input, size),
         {:ok, coord} <- Coordinate.new(r, c)
    do
      {:ok, coord}
    end
  end

  defp translate_input(input, allowable_inputs) do
    cond do
      input in allowable_inputs ->
        {:ok, String.to_integer(input)}

      true -> {:error, "invalid input"}
    end
  end

  defp do_get_move(1, _), do: {1, 1}

  defp do_get_move(input, size) do
    Enum.reduce_while(1..input - 1, {1, 1}, fn n, {r, c} ->
      if rem(n, size) == 0 do
        { :cont, {r + 1, 1} }
      else
        { :cont, {r, c + 1} }
      end
    end)
  end
end
