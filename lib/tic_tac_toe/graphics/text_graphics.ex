defmodule TicTacToe.TextGraphics do
  alias TicTacToe.{Board, Coordinate}
  alias TicTacToe.TextGraphics.{DrawPoints, Points}
  @square_cols 16
  @square_rows 8

  def draw_board(%Board{} = board) do
    rows = board.size * @square_rows
    cols = board.size * @square_cols
    draw_points = DrawPoints.get_points(board, {@square_rows, @square_cols})

    do_draw_board({rows, cols}, cols, fn {r, c} ->
      draw_cell({r, c}, {rows, cols}, draw_points)
    end)
  end

  defp do_draw_board({1, 1}, _c_max, draw), do:
    draw.({1, 1})

  defp do_draw_board({r, 1}, c_max, draw), do:
    draw.({r, 1}) <> do_draw_board({r - 1, c_max}, c_max, draw)

  defp do_draw_board({r, c}, c_max, draw), do:
    draw.({r, c}) <> do_draw_board({r, c - 1}, c_max, draw)

  defp draw_cell({_r, c_max}, {_, c_max}, _),
  do: "\n"

  defp draw_cell({_r, c}, {_, c_max}, _)
  when rem(c, @square_cols) == 0 and c not in [0, c_max],
  do: "|"

  defp draw_cell({r, _c}, {r_max, _}, _)
  when rem(r, @square_rows) == 0 and r not in [0, r_max],
  do: "_"

  defp draw_cell(cell, _,
  %{o_points: o_points, x_points: x_points, label_points: lp}
  ) do
    number_of_squares = length(o_points) + length(x_points) + length(lp)
    board_size = :math.sqrt(number_of_squares) |> trunc
    cond do
      cell in o_points -> "o"
      cell in x_points -> "x"
      cell in lp -> draw_label(cell, board_size)
      true -> " "
    end
  end

  defp draw_label({_r, _c} = drawpoint, board_size) do
    {:ok, %Coordinate{} = square_coord}
      = Points.get_square_coord(
          drawpoint,
          {@square_rows, @square_cols}
        )

    square_center
      = Points.get_square_center(
          square_coord,
          {@square_rows, @square_cols}
        )

    do_draw_label(square_center, drawpoint, square_coord, board_size)
  end

  defp do_draw_label(center, drawpoint, %Coordinate{} = square_coord, board_size)
  when center == drawpoint,
  do: draw_label_center(square_coord, board_size, 0)

  defp do_draw_label({_r1, c1}, {_r, c}, _, _)
  when c1 == c,
  do: "-"

  defp do_draw_label({r1, _c1}, {r, _c}, _, _)
  when r1 == r,
  do: "|"

  defp do_draw_label(_, _, _, _), do: "+"

  defp draw_label_center(%Coordinate{row: 1, col: 1}, _board_size, count),
  do:
    Integer.to_string(count)

  defp draw_label_center(%Coordinate{row: r, col: 1}, board_size, count),
  do:
    draw_label_center(%Coordinate{row: r - 1, col: board_size}, board_size, count + 1)

  defp draw_label_center(%Coordinate{row: r, col: c}, board_size, count),
  do:
    draw_label_center(%Coordinate{row: r, col: c - 1}, board_size, count + 1)

  # defp draw_label_center({r, c}, {r_max, c_max}, count)
  # when c in 1..c_max, do:
  #   draw_label_center({r, c - @square_cols}, {r_max, c_max}, count + 1)
  #
  # defp draw_label_center({r, c}, {r_max, c_max}, count)
  # when r in 1..r_max, do:
  #   draw_label_center({r - @square_rows, c_max}, {r_max, c_max}, count + 1)
  #
  # defp draw_label_center(_, _, count), do: Integer.to_string(count - 1)


end
