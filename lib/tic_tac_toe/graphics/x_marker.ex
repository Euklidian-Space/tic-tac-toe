defmodule TicTacToe.TextGraphics.XMarker do
  alias TicTacToe.TextGraphics.MarkerBehaviour
  @behaviour MarkerBehaviour

  @spec place_marks(String.t(), [{non_neg_integer(), non_neg_integer()}])
    :: {:ok, String.t()}

  def place_marks(board, centers) do
    Stream.map(centers, &get_draw_origin/1)
    |> Stream.flat_map(&get_x_points/1)
    |> Enum.reduce(board, &mark_cell/2)
    |> (fn new_board -> {:ok, new_board} end).()
  end

  def preview do
    {8, 16}
    |> get_draw_origin
    |> get_x_points
    |> List.flatten
    |> Enum.reduce(preview_board(), &mark_cell/2)
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

  defp mark_cell({r, c}, board) do
    rows = String.split(board, "\n") |> Stream.filter(&(&1 != ""))
    row = Enum.at(rows, r - 1)
    new_row = String.slice(row, 0..c - 2) <> "x" <> String.slice(row, c..-1)
    new_board = Enum.slice(rows, 0..r - 2) ++ [new_row] ++ Enum.slice(rows, r..-1)

    Enum.join(new_board, "\n")
  end

  defp preview_board do
    Enum.reduce(1..16, [], fn _, result ->
      [generate_preview_row(32) | result]
    end)
    |> Enum.join
  end

  defp generate_preview_row(count) do
    Enum.reduce(1..count - 1, "", fn _, row ->
      row <> " "
    end) <> "\n"
  end

end
