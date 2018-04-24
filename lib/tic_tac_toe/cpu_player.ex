defmodule TicTacToe.CpuPlayer do
  alias TicTacToe.{Board}
  @initial_best_x {:default, -20}
  @initial_best_o {:default, 20}
  @tie_score 0
  @x_score 10
  @o_score -10

  def get_move(%Board{} = board, x_or_o) do
    case x_or_o do
      :x ->
        choose_profitable_move(board, :x)
      :o ->
        choose_profitable_move(board, :o)
    end
    |> (fn coord -> {:ok, elem(coord, 0)} end).()
  end

  defp choose_profitable_move(board, :x) do
    Enum.reduce_while(board.avail, @initial_best_x, fn coord, current_best ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :x, coord)
      get_score(win_or_not, coord, :x, fn ->
        choose_profitable_move(n_board, :o)
      end)
      |> maximize(current_best, coord)
      |> prune(:x)
    end)
  end

  defp choose_profitable_move(board, :o) do
    Enum.reduce_while(board.avail, @initial_best_o, fn coord, current_best ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :o, coord)
      get_score(win_or_not, coord, :o, fn ->
        choose_profitable_move(n_board, :x)
      end)
      |> minimize(current_best, coord)
      |> prune(:o)
    end)
  end

  defp get_score(:win, candidate, :x, _), do: {candidate, @x_score}
  defp get_score(:win, candidate, :o, _), do: {candidate, @o_score}

  defp get_score(:tie, candidate, _, _), do: {candidate, @tie_score}

  defp get_score(:no_win, _, _, func), do: func.()

  defp maximize({_, candidate_score}, {_, best_score}, curr_coord)
  when candidate_score > best_score,
  do: {curr_coord, candidate_score}

  defp maximize(_, current_best, _), do: current_best

  defp minimize({_, candidate_score}, {_, best_score}, curr_coord)
  when candidate_score < best_score,
  do: {curr_coord, candidate_score}

  defp minimize(_, current_best, _), do: current_best

  defp prune({_coord, maximized_score} = new_best, :x)
  when maximized_score == @x_score,
  do: {:halt, new_best}

  defp prune({_coord, minimized_score} = new_best, :o)
  when minimized_score == @o_score,
  do: {:halt, new_best}

  defp prune(best_so_far, _), do: {:cont, best_so_far}

end










































































  # defp choose_profitable_move(%Board{avail: available_moves}, _)
  # when length(available_moves) == 0, do: {:tie, 0}
  #
  # defp choose_profitable_move(board, :x) do
  #   Enum.reduce_while(board.avail, @initial_best_x, fn coord, current_best ->
  #     {:ok, win_or_not, n_board} = Board.place_mark(board, :x, coord)
  #     o_best = choose_profitable_move(n_board, :o)
  #     current = get_score(win_or_not, :x, current_best, coord)
  #     # if coord.row == 2 and coord.col == 1, do: IO.inspect best
  #     prune(current, o_best, :x)
  #   end)
  # end
  #
  # # defp choose_profitable_move(board, move_score_tuple, :x) do
  # #   Enum.reduce_while(board.avail, move_score_tuple, fn coord, current_best ->
  # #     {:ok, win_or_not, n_board} = Board.place_mark(board, :x, coord)
  # #     coord_score_tup = get_score(win_or_not, :x, current_best, coord)
  # #     best = choose_profitable_move(n_board, coord_score_tup, :o)
  # #     # if coord.row == 2 and coord.col == 1, do: IO.inspect best
  # #     prune(coord_score_tup, best, :x)
  # #   end)
  # # end
  #
  # defp choose_profitable_move(board, :o) do
  #   Enum.reduce_while(board.avail, @initial_best_o, fn coord, current_best ->
  #     {:ok, win_or_not, n_board} = Board.place_mark(board, :o, coord)
  #     coord_score_tup = get_score(win_or_not, :o, current_best, coord)
  #     best = choose_profitable_move(n_board, :x)
  #     prune(coord_score_tup, best, :o)
  #   end)
  # end
  #
  # # defp choose_profitable_move(board, move_score_tuple, :o) do
  # #   Enum.reduce_while(board.avail, move_score_tuple, fn coord, current_best ->
  # #     {:ok, win_or_not, n_board} = Board.place_mark(board, :o, coord)
  # #     coord_score_tup = get_score(win_or_not, :o, current_best, coord)
  # #     best = choose_profitable_move(n_board, coord_score_tup, :x)
  # #     if coord.row == 2 and coord.col == 1, do: IO.inspect best
  # #     prune(coord_score_tup, best, :o)
  # #   end)
  # # end
  #
  # defp get_score(:win, :x, _, candidate), do: {candidate, @x_score}
  # defp get_score(:win, :o, _, candidate), do: {candidate, @o_score}
  #
  # defp get_score(:no_win, _, {:default, default_score}, candidate), do: {candidate, default_score}
  # defp get_score(:no_win, _, current_best, _), do: current_best
  #
  # defp get_score(:tie, _, _, candidate), do: {candidate, @tie_score}
  #
  # defp prune({_, score} = current, _, :x)
  # when score == @x_score,
  # do: {:halt, current}
  #
  # defp prune({_, curr_score} = current, {_, cand_score}, :x)
  # when curr_score >= cand_score,
  # do: {:cont, current}
  #
  # defp prune({_, curr_score}, {_, cand_score} = candidate, :x)
  # when curr_score < cand_score,
  # do: {:cont, candidate}
  #
  # defp prune({_coord, score} = current, _candidate, :o)
  # when score == @o_score,
  # do: {:halt, current}
  #
  # defp prune({_, curr_score} = current, {_, cand_score}, :o)
  # when curr_score <= cand_score,
  # do: {:cont, current}
  #
  # defp prune({_, curr_score}, {_, cand_score} = candidate, :o)
  # when curr_score > cand_score,
  # do: {:cont, candidate}
