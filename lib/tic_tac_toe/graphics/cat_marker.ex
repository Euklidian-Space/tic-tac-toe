defmodule TicTacToe.TextGraphics.CatMarker do
  alias TicTacToe.TextGraphics.MarkerBehaviour
  @behaviour MarkerBehaviour

  @spec place_marks(String.t(), [{non_neg_integer(), non_neg_integer()}])
    :: {:ok, String.t()}

  def place_marks(board_string, centers) do
    {:ok, Enum.reduce(centers, board_string, &mark_cells/2)}
  end

  defp mark_cells({_, _} = center, board_string) do
    build_head(board_string, center)
    |> build_body(center)
  end

  defp build_head(board_string, center) do
    build_row_1(board_string, center)
    |> build_row_2(center)
    |> build_row_3(center)
  end

  defp build_body(board_string, center) do
    build_row_4(board_string, center)
    |> build_row_5(center)
    |> build_row_6(center)
    |> build_row_7(center)
    |> build_row_8(center)
  end

  defp build_row_1(board_string, {r, c}) do
    build_row(board_string, r - 4, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ -> ?( end)
      |> List.update_at(c - 2, fn _ -> ?\\ end)
      |> List.update_at(c - 1, fn _ -> ?_ end)
      |> List.update_at(c, fn _ -> ?/ end)
      |> List.update_at(c + 1, fn _ -> ?) end)
    end)
  end

  defp build_row_2(board_string, {r, c}) do
    build_row(board_string, r - 3, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ -> ?/ end)
      |> List.update_at(c - 2, fn _ -> ?. end)
      |> List.update_at(c, fn _ -> ?. end)
      |> List.update_at(c + 1, fn _ -> ?\\ end)
    end)
  end

  defp build_row_3(board_string, {r, c}) do
    build_row(board_string, r - 2, fn row_char_list ->
      List.update_at(row_char_list, c - 4, fn _ -> ?= end)
      |> List.update_at(c - 3, fn _ -> ?\\ end)
      |> List.update_at(c - 2, fn _ -> ?_ end)
      |> List.update_at(c - 1, fn _ -> ?T end)
      |> List.update_at(c, fn _ -> ?_ end)
      |> List.update_at(c + 1, fn _ -> ?/ end)
      |> List.update_at(c + 2, fn _ -> ?= end)
    end)
  end

  defp build_row_4(board_string, {r, c}) do
    build_row(board_string, r - 1, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ -> ?/ end)
      |> List.update_at(c + 1, fn _ -> ?\\ end)
      |> List.update_at(c + 3, fn _ -> ?. end)
      |> List.update_at(c + 4, fn _ -> ?- end)
      |> List.update_at(c + 5, fn _ -> ?. end)
    end)
  end

  defp build_row_5(board_string, {r, c}) do
    build_row(board_string, r, fn row_char_list ->
      List.update_at(row_char_list, c - 3, fn _ -> ?| end)
      |> List.update_at(c - 1, fn _ -> ?_ end)
      |> List.update_at(c + 1, fn _ -> ?| end)
      |> List.update_at(c + 2, fn _ -> ?/ end)
    end)
  end

  defp build_row_6(board_string, {r, c}) do
    build_row(board_string, r + 1, fn row_char_list ->
      List.update_at(row_char_list, c - 4, fn _ -> ?/ end)
      |> List.update_at(c - 3, fn _ -> ?| end)
      |> List.update_at(c - 1, fn _ -> ?| end)
      |> List.update_at(c + 1, fn _ -> ?| end)
      |> List.update_at(c + 2, fn _ -> ?\\ end)
    end)
  end

  defp build_row_7(board_string, {r, c}) do
    build_row(board_string, r + 2, fn row_char_list ->
      List.update_at(row_char_list, c - 4, fn _ -> ?\\ end)
      |> List.update_at(c - 3, fn _ -> ?) end)
      |> List.update_at(c - 2, fn _ -> ?_ end)
      |> List.update_at(c - 1, fn _ -> ?| end)
      |> List.update_at(c, fn _ -> ?_ end)
      |> List.update_at(c + 1, fn _ -> ?( end)
      |> List.update_at(c + 2, fn _ -> ?/ end)
    end)
  end

  defp build_row_8(board_string, {r, c}) do
    build_row(board_string, r + 3, fn row_char_list ->
      List.update_at(row_char_list, c - 4, fn _ -> ?\` end)
      |> List.update_at(c - 3, fn _ -> ?\" end)
      |> List.update_at(c - 2, fn _ -> ?\" end)
      |> List.update_at(c, fn _ -> ?\" end)
      |> List.update_at(c + 1, fn _ -> ?\" end)
      |> List.update_at(c + 2, fn _ -> ?\` end)
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
