defmodule TicTacToe.CLI do
  alias TicTacToe.{Game, CpuPlayer, TextGraphics, Coordinate}
  alias TicTacToe.CLI.Messages

  def main(_args) do
    Messages.welcome_msg()
    Messages.demo()
    setup()
    |> start_game
  end

  defp setup do
    IO.gets("Are you playing with a friend? (y/n) ")
    |> String.trim()
    |> String.downcase()
    |> case  do
      "y" -> :no_bot
      "n" -> :with_bot
      _ ->
        IO.puts "enter y or n"
        setup()
    end
  end

  defp start_game(:no_bot) do
    {:ok, state} = Game.start_game()
    print_board(state)
    game_loop(state, :no_bot)
    |> Messages.end_message()
    |> Messages.prompt_restart(fn ->
      Game.reset_game(board_size: 3)
      setup()
      |> start_game
    end)
  end

  defp start_game(:with_bot) do
    {:ok, state} = Game.start_game()
    print_board(state)
    game_loop(state, :with_bot)
    |> Messages.end_message()
    |> Messages.prompt_restart(fn ->
      Game.reset_game(board_size: 3)
      setup()
      |> start_game
    end)
  end

  defp game_loop(%Game{winner: :player1}, _),
  do: {:winner, :player1}

  defp game_loop(%Game{winner: :player2}, _),
  do: {:winner, :player2}

  defp game_loop(%Game{rules: %{state: :game_over}}, _),
  do: :tie

  defp game_loop(%Game{} = game_state, :with_bot) do
    with {:ok, new_state}
           <- get_command(game_state) |> execute_command(game_state),
         {:ok, new_state} <- respond_to_player_move(new_state)
    do
      print_board(new_state)
      game_loop(new_state, :with_bot)
    else
      {:error, message} ->
        IO.puts message
        game_loop(game_state, :with_bot)

      :exit -> :exit
    end
  end

  defp game_loop(%Game{} = game_state, :no_bot) do
    with {:ok, %Game{} = new_state}
      <- get_command(game_state) |> execute_command(game_state)
    do
      game_loop(new_state, :no_bot)
    else
      {:error, message} ->
        IO.puts message
        game_loop(game_state, :no_bot)

      :exit -> :exit
    end
  end

  defp get_command(%Game{rules: rules}) do
    IO.puts rules.state
    IO.gets("\n> ")
    |> String.trim
    |> String.downcase
  end

  defp execute_command("quit", _arg2), do: :exit

  defp execute_command(square, %Game{}) do
    with {:ok, %Game{} = new_state}
      <- mark_board(square)
    do
      print_board(new_state)
      {:ok, new_state}
    end
  end

  defp mark_board(%Coordinate{row: r, col: c}),
  do: Game.place_mark(r, c)

  defp mark_board("1"), do: Game.place_mark(1, 1)

  defp mark_board("2"), do: Game.place_mark(1, 2)

  defp mark_board("3"), do: Game.place_mark(1, 3)

  defp mark_board("4"), do: Game.place_mark(2, 1)

  defp mark_board("5"), do: Game.place_mark(2, 2)

  defp mark_board("6"), do: Game.place_mark(2, 3)

  defp mark_board("7"), do: Game.place_mark(3, 1)

  defp mark_board("8"), do: Game.place_mark(3, 2)

  defp mark_board("9"), do: Game.place_mark(3, 3)


  defp mark_board(_), do: {:error, "invalid key"}

  defp print_board(%Game{board: board}) do
    IO.puts TextGraphics.draw_board(board)
  end

  defp respond_to_player_move(%Game{} = game_state) do
    case get_cpu_move(game_state) do
      {:none, _state} -> {:ok, game_state}
      {:ok, coord} -> mark_board(coord)
    end
  end

  defp get_cpu_move(%Game{board: board, rules: rules} = game_state) do
    case rules.state do
      :game_over ->
        {:none, game_state}

      _otherwise -> CpuPlayer.get_move(board, :o)
    end
  end

end
