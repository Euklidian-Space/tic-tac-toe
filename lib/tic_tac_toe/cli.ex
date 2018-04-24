defmodule TicTacToe.CLI do
  alias TicTacToe.{Board, Game, CpuPlayer, TextGraphics, Coordinate}

  def main(_args) do
    IO.puts welcome_msg()
    demo()
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

  defp demo do
    {:ok, board} = Board.new
    {:ok, coord} = Coordinate.new(1, 1)
    {:ok, _, board} = Board.place_mark(board, :x, coord)
    """
    Spaces on the board are numbered 1 through 9 left to right and
    top to bottom. For example enter the number 1.
    """
    |> IO.gets
    IO.puts TextGraphics.draw_board(board)

    IO.puts "The above board is the result."
    IO.gets("Press enter to continue with the demo\n\n")

    {:ok, coord} = Coordinate.new(2, 1)
    {:ok, _, board} = Board.place_mark(board, :o, coord)

    IO.puts TextGraphics.draw_board(board)
    IO.puts "Now if player 2 entered 3 we would get the above board\n\n\n"
  end

  defp start_game(:no_bot) do
    {:ok, state} = Game.start_game()
    print_board(state)
    game_loop(state, :no_bot)
    prompt_restart()
  end

  defp start_game(:with_bot) do
    {:ok, state} = Game.start_game()
    print_board(state)
    game_loop(state, :with_bot)
    prompt_restart()
  end

  defp game_loop(%Game{winner: :player1}, _),
  do: IO.puts win_msg(:player1)

  defp game_loop(%Game{winner: :player2}, _),
  do: IO.puts win_msg(:player2)

  defp game_loop(%Game{rules: %{state: :game_over}}, _),
  do: IO.puts tie_msg()

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
    end
  end

  defp prompt_restart do
    IO.gets("Play again? (y/n)")
    |> String.trim
    |> String.downcase
    |> case  do
      "y" ->
        Game.reset_game()
        setup()
        |> start_game()
      "n" ->
        IO.puts "Goodbye!\n"
      _ ->
        prompt_restart()
    end
  end

  defp get_command(%Game{rules: rules}) do
    IO.puts rules.state
    IO.gets("\n> ")
    |> String.trim
    |> String.downcase
  end

  defp execute_command("quit", _arg2), do: IO.puts "Goodbye!\n\n"

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

  defp welcome_msg do
    """
      888       888          888                                              888
      888   o   888          888                                              888
      888  d8b  888          888                                              888
      888 d888b 888  .d88b.  888  .d8888b .d88b.  88888b.d88b.   .d88b.       888888 .d88b.
      888d88888b888 d8P  Y8b 888 d88P"   d88""88b 888 "888 "88b d8P  Y8b      888   d88""88b
      88888P Y88888 88888888 888 888     888  888 888  888  888 88888888      888   888  888
      8888P   Y8888 Y8b.     888 Y88b.   Y88..88P 888  888  888 Y8b.          Y88b. Y88..88P
      888P     Y888  "Y8888  888  "Y8888P "Y88P"  888  888  888  "Y8888        "Y888 "Y88P"




      88888888888 d8b                888                          88888888888
          888     Y8P                888                              888
          888                        888                              888
          888     888  .d8888b       888888  8888b.   .d8888b         888   .d88b.   .d88b.
          888     888 d88P"          888        "88b d88P"            888  d88""88b d8P  Y8b
          888     888 888     888888 888    .d888888 888     888888   888  888  888 88888888
          888     888 Y88b.          Y88b.  888  888 Y88b.            888  Y88..88P Y8b.
          888     888  "Y8888P        "Y888 "Y888888  "Y8888P         888   "Y88P"   "Y8888



    """
  end

  defp win_msg(:player1) do
     """
       .d8888b.                                             888
      d88P  Y88b                                            888
      888    888                                            888
      888         .d88b.  88888b.   .d88b.  888d888 8888b.  888888 .d8888b
      888        d88""88b 888 "88b d88P"88b 888P"      "88b 888    88K
      888    888 888  888 888  888 888  888 888    .d888888 888    "Y8888b.
      Y88b  d88P Y88..88P 888  888 Y88b 888 888    888  888 Y88b.       X88
       "Y8888P"   "Y88P"  888  888  "Y88888 888    "Y888888  "Y888  88888P'
                                        888
                                   Y8b d88P
                                    "Y88P"

      8888888b.  888                                          d888        888
      888   Y88b 888                                         d8888        888
      888    888 888                                           888        888
      888   d88P 888  8888b.  888  888  .d88b.  888d888        888        888
      8888888P"  888     "88b 888  888 d8P  Y8b 888P"          888        888
      888        888 .d888888 888  888 88888888 888            888        Y8P
      888        888 888  888 Y88b 888 Y8b.     888            888         "
      888        888 "Y888888  "Y88888  "Y8888  888          8888888      888
                                   888
                              Y8b d88P
                               "Y88P"
    """
  end

  defp win_msg(:player2) do
    """
    .d8888b.                                             888
    d88P  Y88b                                            888
    888    888                                            888
    888         .d88b.  88888b.   .d88b.  888d888 8888b.  888888 .d8888b
    888        d88""88b 888 "88b d88P"88b 888P"      "88b 888    88K
    888    888 888  888 888  888 888  888 888    .d888888 888    "Y8888b.
    Y88b  d88P Y88..88P 888  888 Y88b 888 888    888  888 Y88b.       X88
    "Y8888P"   "Y88P"  888  888  "Y88888 888    "Y888888  "Y888  88888P'
                                     888
                                Y8b d88P
                                 "Y88P"

    8888888b.  888                                          .d8888b.       888
    888   Y88b 888                                         d88P  Y88b      888
    888    888 888                                                888      888
    888   d88P 888  8888b.  888  888  .d88b.  888d888           .d88P      888
    8888888P"  888     "88b 888  888 d8P  Y8b 888P"         .od888P"       888
    888        888 .d888888 888  888 88888888 888          d88P"           Y8P
    888        888 888  888 Y88b 888 Y8b.     888          888"             "
    888        888 "Y888888  "Y88888  "Y8888  888          888888888       888
                                888
                           Y8b d88P
                            "Y88P"
    """
  end

  defp tie_msg do
    """
    88888888888 d8b
        888     Y8P
        888
        888     888  .d88b.
        888     888 d8P  Y8b
        888     888 88888888
        888     888 Y8b.
        888     888  "Y8888




     .d8888b.                                  888
    d88P  Y88b                                 888
    888    888                                 888
    888         8888b.  88888b.d88b.   .d88b.  888
    888  88888     "88b 888 "888 "88b d8P  Y8b 888
    888    888 .d888888 888  888  888 88888888 Y8P
    Y88b  d88P 888  888 888  888  888 Y8b.      "
     "Y8888P88 "Y888888 888  888  888  "Y8888  888
    """
  end
end
