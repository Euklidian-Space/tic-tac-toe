defmodule TicTacToe.CpuPlayer do
  alias TicTacToe.{Board}
  @initial_best_x {:default, 20}
  @initial_best_o {:default, -20}
  @x_score 10
  @o_score -10

  def get_move(%Board{} = board, x_or_o) do
    case x_or_o do
      :x ->
        choose_profitable_move(board, @initial_best_x, :x)
      :o ->
        choose_profitable_move(board, @initial_best_o, :o)
    end
    |> (fn coord -> {:ok, elem(coord, 0)} end).()
  end

  defp choose_profitable_move(%Board{avail: available_moves}, move_score_tuple, _)
  when length(available_moves) == 0, do: move_score_tuple

  defp choose_profitable_move(board, move_score_tuple, :x) do
    Enum.reduce_while(board.avail, move_score_tuple, fn coord, current_best ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :x, coord)
      coord_score_tup = get_score(win_or_not, :x, current_best, coord)
      best = choose_profitable_move(n_board, coord_score_tup, :o)
      prune(coord_score_tup, best, :x)
    end)
  end

  defp choose_profitable_move(board, move_score_tuple, :o) do
    Enum.reduce_while(board.avail, move_score_tuple, fn coord, current_best ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :o, coord)
      coord_score_tup = get_score(win_or_not, :o, current_best, coord)
      best = choose_profitable_move(n_board, coord_score_tup, :x)
      prune(coord_score_tup, best, :o)
    end)
  end

  defp get_score(:win, :x, _, candidate), do: {candidate, @x_score}
  defp get_score(:win, :o, _, candidate), do: {candidate, @o_score}
  defp get_score(:no_win, _, {:default, default_score}, candidate), do: {candidate, default_score}
  defp get_score(:no_win, _, current_best, _), do: current_best

  defp prune({_coord, score} = candidate, _current_best, :x)
  when score == @x_score,
  do: {:halt, candidate}

  defp prune(_, current_best, :x), do: {:cont, current_best}

  defp prune({_coord, score} = candidate, _current_best, :o)
  when score == @o_score,
  do: {:halt, candidate}

  defp prune(_, current_best, :o), do: {:cont, current_best}

end
