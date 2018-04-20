defmodule TicTacToe.CpuPlayer do
  alias TicTacToe.Board

  def get_move(%Board{} = board, x_or_o) do
    choose_profitable_move(board, [], x_or_o)
    |> List.first
    |> (fn coord -> {:ok, elem(coord, 0)} end).()
  end

  defp choose_profitable_move(%Board{avail: available_moves}, _scores, _)
  when length(available_moves) == 0, do: :zero_sum_game

  defp choose_profitable_move(board, scores, :x) do
    Enum.reduce(board.avail, scores, fn coord, current_scores ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :x, coord)
      move_score_tuples = get_score(win_or_not, :x, coord, fn ->
        choose_profitable_move(n_board, current_scores, :o) #<--- recursive call here
        |> pick_score(coord, :x)
      end)
      move_score_tuples ++ current_scores
    end)
    # |> pick_score(:x)
  end

  defp choose_profitable_move(board, scores, :o) do
    Enum.reduce(board.avail, scores, fn coord, current_scores ->
      {:ok, win_or_not, n_board} = Board.place_mark(board, :o, coord)
      move_score_tuples = get_score(win_or_not, :o, coord, fn ->
        choose_profitable_move(n_board, current_scores, :x) #<--- recursive call here
        |> pick_score(coord, :o)
      end)
      move_score_tuples ++ current_scores
    end)
    # |> pick_score(:o)
  end

  defp get_score(:win, :x, coord, _), do: [{coord, 10}]
  defp get_score(:no_win, :x, _, func), do: func.()
  defp get_score(:win, :o, coord, _), do: [{coord, -10}]
  defp get_score(:no_win, :o, _, func), do: func.()

  defp get_score(:zero_sum_game, :x , coord), do: [{coord, 10}]
  defp get_score(:zero_sum_game, :o , coord), do: [{coord, -10}]

  defp pick_score(:zero_sum_game, candidate, :o) do
    IO.puts "zero_sum_game"
    get_score(:zero_sum_game, :o,  candidate)
  end

  defp pick_score(scores, candidate, :o) when is_list(scores) do
    Enum.min_by(scores, &(elem(&1, 1)))
    |> chk_for_futile_efforts(:o)
    |> case  do
      true ->
        [{candidate, reward_trap(:x)}]
      move_score_tuple ->
        [move_score_tuple]
    end
  end

  defp pick_score(:zero_sum_game, candidate, :x) do
    IO.puts "zero_sum_game "
    get_score(:zero_sum_game, :x, candidate)
  end

  defp pick_score(scores, candidate, :x) when is_list(scores) do
    Enum.max_by(scores, &(elem(&1, 1)))
    |> chk_for_futile_efforts(:x)
    |> case  do
      true ->
        [{candidate, reward_trap(:o)}]
      move_score_tuple ->
        [move_score_tuple]
    end
  end

  defp chk_for_futile_efforts({_coord, min_score}, :o)
  when min_score >= 10, do: true

  defp chk_for_futile_efforts(move_score_tuple, :o), do:
    move_score_tuple

  defp chk_for_futile_efforts({_coord, max_score}, :x)
  when max_score <= -10, do: true

  defp chk_for_futile_efforts(move_score_tuple, :x), do:
    move_score_tuple

  defp reward_trap(:x), do: 20
  defp reward_trap(:o), do: -20

end
