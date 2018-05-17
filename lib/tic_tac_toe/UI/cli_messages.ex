defmodule TicTacToe.CLI.Messages do
  alias TicTacToe.{Board, Coordinate, TextGraphics}
  @io Application.get_env(:tic_tac_toe, :io, IO)

  def demo() do
    {:ok, board} = Board.new 3
    {:ok, coord} = Coordinate.new(1, 1)
    {:ok, _, board} = Board.place_mark(board, :x, coord)
    markers = %{
      xmarker: TicTacToe.TextGraphics.XMarker,
      omarker: TicTacToe.TextGraphics.OMarker
    }
    label = TicTacToe.TextGraphics.DefaultLabel
    """
    Spaces on the board are numbered 1 through 9 left to right and
    top to bottom. For example enter the number 1.
    """
    |> @io.gets

    {:ok, board_string} = TextGraphics.draw_board(board, markers, label)
    @io.puts board_string

    @io.puts "The above board is the result."
    @io.gets("Press enter to continue with the demo\n\n")

    {:ok, coord} = Coordinate.new(2, 1)
    {:ok, _, board} = Board.place_mark(board, :o, coord)

    {:ok, board_string} = TextGraphics.draw_board(board, markers, label)

    @io.puts board_string
    @io.puts "Now if player 2 entered 4 we would get the above board\n\n\n"
  end

  def demo_prompt do
    @io.gets("Would you like a demo? (y/n) ")
    |> normalize_input
    |> case do
      "y" -> :demo

      "n" -> :no_demo

      _ -> {:error, "enter y or n\n"}
    end
  end

  def end_message(end_state) do
    case end_state do
      {:winner, :player1} ->
        @io.puts win_msg(:player1)
        :ok
      {:winner, :player2} ->
        @io.puts win_msg(:player2)
        :ok
      :tie ->
        @io.puts tie_msg()
        :ok
      :exit ->
        @io.puts "Goodbye!\n\n\n"
        :no_restart
      _otherwise ->
        @io.puts "An error has occurred..."
        {:error, :unrecognized_state}
    end
  end

  def prompt_restart(:no_restart, _), do: :ok
  def prompt_restart(:ok, restart_fun) do
    @io.gets("Play again? (y/n)")
    |> normalize_input
    |> case do
      "y" ->
        restart_fun.()
      "n" ->
        @io.puts "Goodbye!\n"
      _ ->
        prompt_restart(:ok, restart_fun)
    end
  end

  def bot_query do
    @io.gets("Are you playing with a friend? (y/n) ")
    |> normalize_input
    |> case do
      "y" -> {:ok, :no_bot}
      "n" -> {:ok, :with_bot}
      _ -> {:error, "enter y or n"}
    end
  end

  def marker_query(custom_msg) do
    @io.gets(custom_msg)
    |> normalize_input
    |> case do
      "n" -> {:ok, :rand_marker}
      "y" -> {:ok, :custom_marker}
      _ -> {:error, "enter y or n"}
    end
  end

  def marker_prompt(markers, custom_msg, :with_prev) do
    Enum.reduce(markers, 1, fn {_, marker}, num ->
      @io.puts(marker.preview() <> "#{num}\n")
      num + 1
    end)
    input = @io.gets(custom_msg) |> normalize_input

    allowable_inputs = Enum.map(1..length(markers), &Integer.to_string/1)
    case input in allowable_inputs do
      true -> {:ok, input}

      _otherwise -> {:error, "enter a number between 1 and #{length(markers)}"}
    end
  end

  def marker_prompt(markers, custom_msg, :no_prev) do
    input = @io.gets(custom_msg)
            |> normalize_input
    allowable_inputs = Enum.map(1..length(markers), &Integer.to_string/1)
    case input in allowable_inputs do
      true -> {:ok, input}

      _otherwise -> {:error, "enter a number between 1 and #{length(markers)}"}
    end
  end

  defp normalize_input(input) do
    String.trim(input)
    |> String.downcase()
  end

  def welcome_msg do
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



    """ |> @io.puts
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
