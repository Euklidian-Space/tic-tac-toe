defmodule TicTacToe.TextGraphics.DefaultLabel do
  alias TicTacToe.Coordinate
  alias TicTacToe.TextGraphics.LabelBehaviour
  @behaviour LabelBehaviour

  @spec place_labels(
    String.t(),
    non_neg_integer,
    [{%Coordinate{}, {non_neg_integer(), non_neg_integer()}}]
  ) :: {:ok, String.t()}

  def place_labels(board_string, board_size, coord_centers) do
    Enum.reduce(coord_centers, board_string, fn {_, {_, _}} = cs, b_string ->
      mark_cells(cs, b_string, board_size)
    end)
    |> (fn new_board_string -> {:ok, new_board_string} end).()
  end

  defp mark_cells({%Coordinate{} = coord, center}, b_string, board_size)
  do
    square_num = get_square_number(coord, {1, 1}, board_size)
    |> Integer.to_string

    build_row_1(b_string, center, String.length(square_num))
    |> build_row_2(center, String.to_charlist(square_num))
    |> build_row_3(center, String.length(square_num))
  end

  defp get_square_number(%Coordinate{row: r, col: c}, {r, c}, _),
  do: 1

  defp get_square_number(target, {curr_r, max}, max),
  do: 1 + get_square_number(target, {curr_r + 1, 1}, max)

  defp get_square_number(target, {curr_r, curr_c}, max)
  when curr_c <= max and curr_r <= max,
  do: 1 + get_square_number(target, {curr_r, curr_c + 1}, max)

  defp build_row_1(b_string, {r, c}, 1) do
    build_row(b_string, r - 1, fn row_char_list ->
      List.update_at(row_char_list, c - 2, fn _ -> ?+ end)
      |> List.update_at(c - 1, fn _ -> ?- end)
      |> List.update_at(c, fn _ -> ?+ end)
    end)
  end

  defp build_row_1(b_string, {r, c}, 2) do
    build_row(b_string, r - 1, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ -> ?+ end)
      |> List.update_at(c - 2, fn _ -> ?+ end)
      |> List.update_at(c - 1, fn _ -> ?- end)
      |> List.update_at(c, fn _ -> ?+ end)
      |> List.update_at(c + 1, fn _ -> ?+ end)
    end)
  end

  defp build_row_2(b_string, {r, c}, [digitA, digitB]) do
    build_row(b_string, r, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ -> ?| end)
      |> List.update_at(c - 2, fn _ -> digitA end)
      |> List.update_at(c - 1, fn _ -> digitB end)
      |> List.update_at(c, fn _ -> ?| end)
    end)
  end

  defp build_row_2(b_string, {r, c}, [digit]) do
    build_row(b_string, r, fn row_char_list ->
      List.update_at(row_char_list, c - 2, fn _ -> ?| end)
      |> List.update_at(c - 1, fn _ -> digit end)
      |> List.update_at(c, fn _ -> ?| end)
    end)
  end

  defp build_row_3(b_string, {r, c}, 1) do
    build_row(b_string, r + 1, fn row_char_list ->
      List.update_at(row_char_list, c - 2, fn _ ->  ?+ end)
      |> List.update_at(c - 1, fn _ -> ?- end)
      |> List.update_at(c, fn _ -> ?+ end)
    end)
  end

  defp build_row_3(b_string, {r, c}, 2) do
    build_row(b_string, r + 1, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ ->  ?+ end)
      |> List.update_at(c - 2, fn _ -> ?- end)
      |> List.update_at(c - 1, fn _ -> ?- end)
      |> List.update_at(c, fn _ -> ?+ end)
    end)
  end

  defp build_row(board_string, row_number, fun) do
    rows = String.split(board_string, "\n") |> Enum.filter(&(&1 != ""))
    row = Enum.at(rows, row_number) |> String.to_charlist

    List.update_at(rows, row_number, fn _ ->
      fun.(row) |> List.to_string
    end)
    |> Enum.join("\n")
  end

end
