defmodule TicTacToe.CLI do
  alias TicTacToe.{Game, DefaultPlayer, TextGraphics, Coordinate}
  alias TicTacToe.CLI.Messages
  @label TextGraphics.DefaultLabel
  @markers Application.get_env(
    :tic_tac_toe,
    :markers,
    [x: TextGraphics.XMarker, o: TextGraphics.OMarker]
  )
  @players Application.get_env(
    :tic_tac_toe,
    :players,
    [default: DefaultPlayer]
  )

  def main(_args) do
    Messages.welcome_msg()
    demo_prompt()
    setup()
    |> (fn {players, markers} -> start_game(players, markers) end).()
  end

  defp demo_prompt do
    case Messages.demo_prompt() do
      :demo -> Messages.demo()

      {:error, msg} ->
        IO.puts msg <> "\n"
        demo_prompt()

      # _otherwise -> :ok
    end
  end

  defp setup do
    with {:ok, bot_or_not} <- Messages.bot_query(),
         {:ok, query_results} <- marker_query(bot_or_not),
         {:ok, players} <- process_bot_query(bot_or_not),
         {:ok, markers} <- process_marker_query(query_results)
    do
      {players, markers}
    else
      _ ->
        IO.puts "A problem with the setup process occurred. Restarting...\n"
        setup()
    end
  end

  defp marker_query(:with_bot),
  do: { :ok, [x: do_marker_query(:x), o: :rand_marker] }

  defp marker_query(:no_bot),
  do: { :ok, [x: do_marker_query(:x), o: do_marker_query(:o)] }

  defp do_marker_query(:x) do
    msg = "Would player 1 like to choose their own marker? (y/n) "
    case Messages.marker_query(msg) do
      {:error, err_msg} ->
        IO.puts err_msg <> "\n"
        do_marker_query(:x)

      {:ok, custom_or_rand} -> custom_or_rand
    end
  end

  defp do_marker_query(:o) do
    msg = "Would player 2 like to choose their own marker? (y/n) "
    case Messages.marker_query(msg) do
      {:error, err_msg} ->
        IO.puts err_msg <> "\n"
        do_marker_query(:o)

      {:ok, custom_or_rand} -> custom_or_rand
    end
  end

  defp process_bot_query(:with_bot) do
    players = [
      x: Keyword.fetch!(@players, :default),
      o: Keyword.fetch!(@players, :cpu)
    ]
    {:ok, players}
  end

  defp process_bot_query(:no_bot) do
    players = [
      x: Keyword.fetch!(@players, :default),
      o: Keyword.fetch!(@players, :default)
    ]
    {:ok, players}
  end

  defp process_marker_query(query_results, prev_or_not \\ :with_prev) do
    xres = Keyword.fetch!(query_results, :x)
    ores = Keyword.fetch!(query_results, :o)
    x_choice = do_process_marker_query(prev_or_not, x: xres)
    o_choice = choose(x_choice, ores, fn ->
      do_process_marker_query(prev_or_not, o: ores)
    end)

    xmarker = Keyword.values(@markers)
              |> Enum.at(x_choice - 1)

    omarker = Keyword.values(@markers)
              |> Enum.at(o_choice - 1)

    {:ok, [x: xmarker, o: omarker]}
  end

  defp do_process_marker_query(_, x: :rand_marker),
  do: Enum.random(1..length(@markers))

  defp do_process_marker_query(_, o: :rand_marker),
  do: Enum.random(1..length(@markers))

  defp do_process_marker_query(prev_or_not, [query_result]) do
    msg = case query_result do
      { :x, :custom_marker } ->
        """
        Player 1, choose which maker you would from the above previews by entering
        its corresponding number.
        """
      { :o, :custom_marker } ->
        """
        Player 2, choose which maker you would from the above previews by entering
        its corresponding number.
        """
    end

    case Messages.marker_prompt(@markers, msg, prev_or_not) do
      {:error, err_msg} ->
        IO.puts err_msg <> "\n"
        do_process_marker_query(prev_or_not, [query_result])

      {:ok, input} -> String.to_integer(input)
    end
  end

  defp choose(others_choice, cust_or_rand, fun) do
    new_choice = fun.()
    if others_choice == new_choice do
      if cust_or_rand == :custom_marker,
      do: IO.puts "Marker already taken.  Please choose another\n"

      choose(others_choice, :custom_marker, fun)
    else
      new_choice
    end
  end

  defp start_game(players, markers) do
    {:ok, state} = Game.start_game()
    print_board(state, markers, @label)
    game_loop(state, players, markers)
    |> Messages.end_message()
    |> Messages.prompt_restart(&restart_game/0)
  end

  defp restart_game() do
    Game.reset_game(board_size: 3)
    setup()
    |> (fn {players, markers} -> start_game(players, markers) end).()
  end

  defp game_loop(%Game{winner: :player1}, _, _),
  do: {:winner, :player1}

  defp game_loop(%Game{winner: :player2}, _, _),
  do: {:winner, :player2}

  defp game_loop(%Game{rules: %{state: :game_over}}, _, _),
  do: :tie

  defp game_loop(%Game{} = game_state, players, markers) do
    player1 = Keyword.fetch!(players, :x)
    player2 = Keyword.fetch!(players, :o)

    Enum.reduce([player1, player2], game_state, fn player, curr_state ->
      get_player_move(player, curr_state)
      |> print_board(markers, @label)
    end)
    |> game_loop(players, markers)
  end

  defp get_player_move(_, %Game{rules: %{state: :game_over}} = game_state),
  do: game_state

  defp get_player_move(player, game_state) do
    case player.get_move(game_state) do
      {:error, err_msg} ->
        IO.puts err_msg <> "\n"
        get_player_move(player, game_state)
      {:ok, move} ->
        commit_move(move, player, game_state)
    end
  end

  defp commit_move(%Coordinate{row: r, col: c}, player, game_state) do
    case Game.place_mark(r, c) do
      {:error, err_msg} ->
        IO.puts err_msg <> "\n"
        get_player_move(player, game_state)

      {:ok, new_state} -> new_state
    end
  end

  defp print_board(%Game{board: board} = game_state, markers, label) do
    xmarker = Keyword.fetch!(markers, :x)
    omarker = Keyword.fetch!(markers, :o)
    ms = %{omarker: omarker, xmarker: xmarker}
    {:ok, board_string} = TextGraphics.draw_board(board, ms, label)
    IO.puts board_string
    game_state
  end
end
