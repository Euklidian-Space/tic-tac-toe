defmodule TicTacToe.TextGraphics.OMarker do
  alias TicTacToe.TextGraphics.MarkerBehaviour
  @behaviour MarkerBehaviour

  @spec place_marks(String.t(), [{non_neg_integer(), non_neg_integer()}])
    :: {:ok, String.t()}

  def place_marks(board, centers) do
    Stream.map(centers, &get_draw_origin/1)
    |> Stream.flat_map(&get_o_points/1)
    |> Enum.reduce(board, &mark_cell/2)
    |> (fn new_board -> {:ok, new_board} end).()
  end

  def preview do
    {8, 16}
    |> get_draw_origin
    |> get_o_points
    |> List.flatten
    |> Enum.reduce(preview_board(), &mark_cell/2)
  end

  defp get_draw_origin({r, c}) do
    {r, c - 5}
  end

  defp get_o_points({_, c} = left_most) do
    o_top_half(left_most, c + 10, [])
    ++
    o_bottom_half(left_most, c + 10, [])
  end

  defp o_top_half({r, c}, c_max, result)
  when c < c_max - 8,
  do:
    o_top_half({r - 1, c + 1}, c_max, [{r, c} | result])

  defp o_top_half({r, c}, c_max, result)
  when c < c_max - 2,
  do:
    o_top_half({r, c + 2}, c_max, [{r, c} | result])

  defp o_top_half({r, c}, c_max, result)
  when c <= c_max,
  do:
    o_top_half({r + 1, c + 1}, c_max, [{r, c} | result])

  defp o_top_half(_, _, result), do: result

  defp o_bottom_half({r, c}, c_max, result)
  when c < c_max - 8,
  do:
    o_bottom_half({r + 1, c + 1}, c_max, [{r, c} | result])

  defp o_bottom_half({r, c}, c_max, result)
  when c < c_max - 2,
  do:
    o_bottom_half({r, c + 2}, c_max, [{r, c} | result])

  defp o_bottom_half({r, c}, c_max, result)
  when c <= c_max,
  do:
    o_bottom_half({r - 1, c + 1}, c_max, [{r, c} | result])

  defp o_bottom_half(_, _, result), do: result

  defp mark_cell({r, c}, board) do
    rows = String.split(board, "\n") |> Stream.filter(&(&1 != ""))
    row = Enum.at(rows, r - 1)

    new_row = String.slice(row, 0..c - 2) <> "o" <> String.slice(row, c..-1)
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
