defmodule TicTacToe.TextGraphics do
  alias TicTacToe.{Board, Coordinate}
  alias TicTacToe.TextGraphics.{DrawPoints, Points}
  @rows 24
  @cols 48
  @row_mod 8
  @col_mod 16

  def draw_board(%Board{} = board) do
    %{
      x_points: DrawPoints.get_points(board, :x),
      o_points: DrawPoints.get_points(board, :o),
      label_points: DrawPoints.get_points(board, :avail)
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

  defp draw_cell(cell,
  %{o_points: o_points, x_points: x_points, label_points: lp}
  ) do
    cond do
      cell in o_points -> "o"
      cell in x_points -> "x"
      cell in lp -> draw_label(cell)
      true -> " "
    end
  end

  defp draw_label({_r, _c} = drawpoint) do
    {:ok, %Coordinate{} = square_coord} = Points.get_square_coord(drawpoint)
    square_center = Points.get_square_center(square_coord)
    do_draw_label(square_coord, square_center, drawpoint)
  end

  defp do_draw_label(%Coordinate{row: 1, col: 1}, center, drawpoint)
  when center == drawpoint,
  do: "1"

  defp do_draw_label(%Coordinate{row: 1, col: 2}, center, drawpoint)
  when center == drawpoint,
  do: "2"

  defp do_draw_label(%Coordinate{row: 1, col: 3}, center, drawpoint)
  when center == drawpoint,
  do: "3"

  defp do_draw_label(%Coordinate{row: 2, col: 1}, center, drawpoint)
  when center == drawpoint,
  do: "4"

  defp do_draw_label(%Coordinate{row: 2, col: 2}, center, drawpoint)
  when center == drawpoint,
  do: "5"

  defp do_draw_label(%Coordinate{row: 2, col: 3}, center, drawpoint)
  when center == drawpoint,
  do: "6"

  defp do_draw_label(%Coordinate{row: 3, col: 1}, center, drawpoint)
  when center == drawpoint,
  do: "7"

  defp do_draw_label(%Coordinate{row: 3, col: 2}, center, drawpoint)
  when center == drawpoint,
  do: "8"

  defp do_draw_label(%Coordinate{row: 3, col: 3}, center, drawpoint)
  when center == drawpoint,
  do: "9"

  defp do_draw_label(_, {_r1, c1}, {_r, c})
  when c1 == c,
  do: "-"

  defp do_draw_label(_, {r1, _c1}, {r, _c})
  when r1 == r,
  do: "|"

  defp do_draw_label(_, _, _), do: "+"


end
