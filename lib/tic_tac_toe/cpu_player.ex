defmodule TicTacToe.CpuPlayer do
  alias TicTacToe.Board

  def get_move(%Board{} = board, x_or_o) do
    choose_profitable_move(board, [], x_or_o)
    |> List.first
    |> (fn coord -> {:ok, elem(coord, 0)} end).()
  end

  defp choose_profitable_move(%Board{avail: available_moves}, _scores, _)
  when length(available_moves) == 0, do: []

  defp choose_profitable_move(board, scores, :x) do
    Enum.reduce(board.avail, scores, fn coord, current_scores ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :x, coord)
      move_score_tuples = get_score(win_or_not, :x, coord, fn ->
        choose_profitable_move(n_board, current_scores, :o) #<--- recursive call here
      end)
      move_score_tuples ++ current_scores
    end)
    |> (fn move_score_tuples ->
      [Enum.max_by(move_score_tuples, &(elem(&1, 1)))]
    end).()
  end

  defp choose_profitable_move(board, scores, :o) do
    Enum.reduce(board.avail, scores, fn coord, current_scores ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :o, coord)
      move_score_tuples = get_score(win_or_not, :o, coord, fn ->
        choose_profitable_move(n_board, current_scores, :x) #<--- recursive call here
      end)
      move_score_tuples ++ current_scores
    end)
    |> (fn move_score_tuples ->
      [Enum.min_by(move_score_tuples, &(elem(&1, 1)))]
    end).()
  end

  defp get_score(:win, :x, coord, _), do: [{coord, 10}]
  defp get_score(:win, :o, coord, _), do: [{coord, -10}]
  defp get_score(:no_win, _, _, func), do: func.()

end
