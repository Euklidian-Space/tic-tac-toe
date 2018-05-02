defmodule TicTacToe.TextGraphics.Points do
  alias TicTacToe.Coordinate

  def get_square_center(%Coordinate{row: r, col: c}, square_dimensions) do
    {rows, cols} = square_dimensions
    curr_row = div(rows, 2)
    curr_col = div(cols, 2)
    {
      do_get_square_center(curr_row, rows, r),
      do_get_square_center(curr_col, cols, c)
    }
  end

  def get_square_coord(location, square_dimensions) do
    {r, c} = location
    {r_offset, c_offset} = square_dimensions
    coord_row = do_get_square_coord(r, r_offset, 1)
    coord_col = do_get_square_coord(c, c_offset, 1)
    Coordinate.new(coord_row, coord_col)
  end

  defp do_get_square_center(curr_center, _, target)
  when target <= 1,
  do: curr_center

  defp do_get_square_center(curr_center, offset, target), do:
    do_get_square_center(curr_center + offset, offset, target - 1)

  defp do_get_square_coord(curr_loc, offset, result)
  when curr_loc <= offset,
  do: result

  defp do_get_square_coord(curr_loc, offset, result), do:
    do_get_square_coord(curr_loc - offset, offset, result + 1)

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 1 and c == 1,
  do: {4, 8}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 1 and c == 2,
  do: {4, 24}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 1 and c == 3,
  do: {4, 40}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 2 and c == 1,
  do: {12, 8}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 2 and c == 2,
  do: {12, 24}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 2 and c == 3,
  do: {12, 40}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 3 and c == 1,
  do: {20, 8}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 3 and c == 2,
  do: {20, 24}

  def get_square_center(%Coordinate{row: r, col: c})
  when r == 3 and c == 3,
  do: {20, 40}

  def get_square_coord({r, c})
  when r in 0..8 and c in 0..16,
  do: Coordinate.new(1,1)

  def get_square_coord({r, c})
  when r in 0..8 and c in 17..36,
  do: Coordinate.new(1,2)

  def get_square_coord({r, c})
  when r in 0..8 and c in 37..48,
  do: Coordinate.new(1,3)

  def get_square_coord({r, c})
  when r in 9..16 and c in 0..16,
  do: Coordinate.new(2,1)

  def get_square_coord({r, c})
  when r in 9..16 and c in 17..36,
  do: Coordinate.new(2,2)

  def get_square_coord({r, c})
  when r in 9..16 and c in 37..48,
  do: Coordinate.new(2,3)

  def get_square_coord({r, c})
  when r in 17..24 and c in 0..16,
  do: Coordinate.new(3,1)

  def get_square_coord({r, c})
  when r in 17..24 and c in 17..36,
  do: Coordinate.new(3,2)

  def get_square_coord({r, c})
  when r in 17..24 and c in 37..48,
  do: Coordinate.new(3,3)
end
