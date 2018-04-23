defmodule TicTacToe.TextGraphics do
  alias TicTacToe.{Board}
  alias TicTacToe.TextGraphics.DrawPoints
  @rows 24
  @cols 48
  @row_mod 8
  @col_mod 16

  def draw_board(%Board{} = board) do
    %{
      x_points: DrawPoints.get_points(board, :x),
      o_points: DrawPoints.get_points(board, :o)
    } |> do_draw_board(1, 1, "")
  end

  defp do_draw_board(x_o_draw_points, row, col, result)
  when col == @cols
  do
    result = result <> draw_cell({row, col}, x_o_draw_points)
    do_draw_board(x_o_draw_points, row + 1, 1, result)
  end

  defp do_draw_board(x_o_draw_points, row, col, result)
  when row in 1..@rows and col in 1..@cols
  do
    result = result <> draw_cell({row, col}, x_o_draw_points)
    do_draw_board(x_o_draw_points, row, col + 1, result)
  end

  defp do_draw_board(_, _, _, result), do: result


  defp draw_cell({_r, c}, _)
  when c == @cols,
  do: "\n"

  defp draw_cell({_r, c}, _)
  when rem(c, @col_mod) == 0 and c not in [0, @cols],
  do: "|"

  defp draw_cell({r, _c}, _)
  when rem(r, @row_mod) == 0 and r not in [0, @rows],
  do: "_"

  defp draw_cell(cell, %{o_points: o_points, x_points: x_points}) do
    cond do
      cell in o_points -> "o"
      cell in x_points -> "x"
      true -> " "
    end
  end

end
