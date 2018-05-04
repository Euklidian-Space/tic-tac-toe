defmodule TicTacToe.TextGraphics.XMarker do
  alias TicTacToe.TextGraphics.MarkerBehaviour
  @behaviour MarkerBehaviour

  @spec place_marks([{non_neg_integer(), non_neg_integer()}], String.t())
    :: {:ok, String.t()} | {:error, String.t()}
  def place_marks(centers, board) do
    Stream.map(centers, &get_draw_origin/1)
    |> Stream.flat_map(&get_x_points/1)
    |> Enum.reduce_while(board, &mark_cell/2)
    |> (fn
      {:error, :off_board} ->
        {:error, off_board_msg(centers)}
      new_board ->
        {:ok, new_board}
      end).()
  end

  defp get_draw_origin({r, c}) do
    {r - 2, c - 4}
  end

  defp get_x_points({r, c} = upper_left) do
    x_main_diagonal({r + 4, c}, c + 8, [])
    ++
    x_off_diagonal(upper_left, c + 8, [])
  end

  defp x_main_diagonal({r, c}, c_max, result)
  when c <= c_max
  do
    x_main_diagonal({r - 1, c + 2}, c_max, [{r, c} | result])
  end

  defp x_main_diagonal(_, _, result), do: result

  defp x_off_diagonal({r, c}, c_max, result)
  when c <= c_max
  do
    x_off_diagonal({r + 1, c + 2}, c_max, [{r, c} | result])
  end

  defp x_off_diagonal(_, _, result), do: result

  defp mark_cell({r, c}, _)
  when r < 1 or c < 1,
  do: {:halt, {:error, :off_board}}

  defp mark_cell({r, c}, board) do
    rows = String.split(board, "\n") |> Stream.filter(&(&1 != ""))
    row = Enum.at(rows, r - 1)

    if r > Enum.count(rows) or c > String.length(row) do
      {:halt, {:error, :off_board}}
    else
      new_row = String.slice(row, 0..c - 2) <> "x" <> String.slice(row, c..-1)
      new_board = Enum.slice(rows, 0..r - 2) ++ [new_row] ++ Enum.slice(rows, r..-1)

      {:cont, Enum.join(new_board, "\n")}
    end
  end

  defp off_board_msg(centers), do:
    "XMarker off board. Perhaps one of the given centers: #{inspect centers} is invalid?"

end
