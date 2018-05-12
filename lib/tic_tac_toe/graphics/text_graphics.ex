defmodule TicTacToe.TextGraphics do
  alias TicTacToe.{Board}
  alias TicTacToe.TextGraphics.Points
  @square_cols 32
  @square_rows 16

  def draw_board(%Board{} = board, %{xmarker: _, omarker: _} = markers) do
    rows = board.size * @square_rows - 1
    cols = board.size * @square_cols - 1
    do_draw_board({rows, cols}, cols, fn {r, c} ->
      draw_cell({r, c}, {rows, cols})
    end)
    |> draw_marks(markers, board)
  end

  defp do_draw_board({0, 0}, _c_max, _draw), do: ""

  defp do_draw_board({r, 0}, c_max, draw), do:
    draw.({r, 0}) <> do_draw_board({r - 1, c_max}, c_max, draw)

  defp do_draw_board({r, c}, c_max, draw), do:
    draw.({r, c}) <> do_draw_board({r, c - 1}, c_max, draw)

  defp draw_cell({_r, c_max}, {_, c_max}),
  do: "\n"

  defp draw_cell({_r, c}, {_, c_max})
  when rem(c, @square_cols) == 0 and c not in [0, c_max],
  do: "|"

  defp draw_cell({r, _c}, {r_max, _})
  when rem(r, @square_rows) == 0 and r not in [0, r_max],
  do: "_"

  defp draw_cell(_, _), do: " "

  defp draw_marks(board_string, %{xmarker: xm, omarker: om}, %Board{} = board) do
    %{x_centers: xcs, o_centers: ocs} = centers(board)
    xm.place_marks(board_string, xcs)
    |> case do
      {:error, _} = err -> err
      {:ok, n_board_string} -> om.place_marks(n_board_string, ocs)
    end
  end

  defp centers(%Board{o: os, x: xs}) do
    o_centers = Enum.map(os, fn coord ->
      Points.get_square_center(coord, {@square_rows, @square_cols})
    end)

    x_centers = Enum.map(xs, fn coord ->
      Points.get_square_center(coord, {@square_rows, @square_cols})
    end)

    %{x_centers: x_centers, o_centers: o_centers}
  end

end
