defmodule TicTacToe.TextGraphics.DrawPoints do
  alias TicTacToe.{Board}
  alias TicTacToe.TextGraphics.Points

  def get_points(%Board{x: xs}, :x) do
    Stream.map(xs, &Points.get_square_center/1)
    |> Stream.map(fn sq_center -> get_draw_origin(sq_center, :x) end)
    |> Enum.flat_map(&get_x_points/1)
  end

  def get_points(%Board{o: os}, :o) do
    Stream.map(os, &Points.get_square_center/1)
    |> Stream.map(fn sq_center -> get_draw_origin(sq_center, :o) end)
    |> Enum.flat_map(&get_o_points/1)
  end

  def get_points(%Board{avail: avail}, :avail) do
    Stream.map(avail, &Points.get_square_center/1)
    |> Enum.flat_map(&get_label_points/1)
  end

  defp get_draw_origin({r, c}, :o) do
    {r, c - 5}
  end

  defp get_draw_origin({r, c}, :x) do
    {r - 2, c - 4}
  end

  defp get_o_points({_, c} = left_most) do
    o_top_half(left_most, c + 10, [])
    ++
    o_bottom_half(left_most, c + 10, [])
  end

  defp get_x_points({r, c} = upper_left) do
    x_main_diagonal({r + 4, c}, c + 8, [])
    ++
    x_off_diagonal(upper_left, c + 8, [])
  end

  defp get_label_points({r, c}) do
    [
      {r - 1, c - 1}, {r - 1, c}, {r - 1, c + 1},
      {r, c - 1}, {r, c}, {r, c + 1},
      {r + 1, c - 1}, {r + 1, c}, {r + 1, c + 1}
    ]
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

end
