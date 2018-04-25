defmodule TicTacToe.TextGraphics.Points do
  alias TicTacToe.Coordinate

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
