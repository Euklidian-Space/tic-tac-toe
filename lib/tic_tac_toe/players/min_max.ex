defmodule TicTacToe.MinMax do
  alias TicTacToe.{Board}
  @initial_best_x {:default, -20}
  @initial_best_o {:default, 20}
  @tie_score 0
  @x_score 10
  @o_score -10


  def get_move(%Board{} = board, mark) do
    case mark do
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
