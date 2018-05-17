defmodule TicTacToe.CliMessagesTest do
  use ExUnit.Case, async: true
  import Mox
  alias TicTacToe.CLI.Messages
  alias TicTacToe.{IOMock}

  setup :verify_on_exit!

  describe "demo/0" do
    test "should return :ok and display messages to user" do
      IOMock
      |> expect(:puts, 4, fn data ->
        send self(), {:puts, data}
        :ok
      end)
      |> expect(:gets, 2, fn data ->
        send self(), {:gets, data}
        data
      end)
      assert :ok = Messages.demo()
      assert_received({:puts, "The above board is the result."})
      assert_received({:puts, "Now if player 2 entered 4 we would get the above board\n\n\n"})
      assert_received({:gets, "Press enter to continue with the demo\n\n"})
    end
  end

  describe "demo_prompt/0" do
    test "should print 'Would you like a demo? (y/n)'" do
      expected_msg = "Would you like a demo? (y/n) "
      IOMock
      |> expect(:gets, fn data ->
        send self(), {:gets, data}
        "y\n"
      end)

      assert :demo = Messages.demo_prompt()
      assert_received {:gets, ^expected_msg}
    end

    test "should return :no_demo for input 'n'" do
      IOMock
      |> expect(:gets, fn _ -> "N\n" end)

      assert :no_demo = Messages.demo_prompt()
    end

    test "should return error tuple for invalid input" do
      IOMock
      |> expect(:gets, fn _data -> "invalid input" end)

      assert {:error, "enter y or n\n"} = Messages.demo_prompt()
    end
  end

  describe "end_message/1" do
    setup do
      IOMock
      |> expect(:puts, fn data ->
        send self(), {:puts, data}
      end)
      :ok
    end

    test "should respond to {:winner, :player1}" do
      expected_msg = win_msg_player1()
      assert :ok = Messages.end_message({:winner, :player1})
      assert_received {:puts, received_msg}
      assert received_msg == expected_msg
    end

    test "should respond to {:winner, :player2}" do
      expected_msg = win_msg_player2()
      assert :ok = Messages.end_message({:winner, :player2})
      assert_received {:puts, received_msg}
      assert received_msg == expected_msg
    end

    test "should respond to :tie" do
      expected_msg = tie_msg()
      assert :ok = Messages.end_message(:tie)
      assert_received {:puts, received_msg}
      assert received_msg == expected_msg
    end

    test "should respond to :exit" do
      expected_msg = "Goodbye!\n\n\n"
      assert :no_restart = Messages.end_message(:exit)
      assert_received {:puts, received_msg}
      assert received_msg == expected_msg
    end

    test "sould return error tuple for unrecognized end_state" do
      expected_msg = "An error has occurred..."
      assert {:error, :unrecognized_state} = Messages.end_message(:invalid_state)
      assert_received {:puts, ^expected_msg}
    end
  end

  describe "welcome_msg/0" do
    setup do
      IOMock |> expect(:puts, fn data ->
        send self(), {:puts, data}
        :ok
      end)
      :ok
    end

    test "should display welcome message" do
      assert :ok = Messages.welcome_msg()
      assert_received {:puts, received_msg}
      assert received_msg == welcome_msg()
    end
  end

  describe "prompt_restart/2" do
    setup do
      restart_fun = fn -> send(self(), :restart_fun_called) end
      {:ok, restart_fun: restart_fun}
    end

    test "restart function is called if 'y' is entered by user",
    %{restart_fun: fun}
    do
      IOMock
      |> expect(:gets, fn _ -> "y" end)
      Messages.prompt_restart(:ok, fun)
      assert_received :restart_fun_called
    end

    test "displays goodbye message if 'n' is entered by user",
    %{restart_fun: fun}
    do
      IOMock
      |> expect(:puts, fn data ->
        send self(), {:puts, data}
        :ok
      end)
      |> expect(:gets, fn _ -> "n" end)

      expected_msg = "Goodbye!\n"
      assert :ok = Messages.prompt_restart(:ok, fun)
      assert_received {:puts, ^expected_msg}
      refute_received :restart_fun_called
    end
  end

  describe "bot_query/0" do
    test "should ask user if they are playing with a friend" do
      IOMock
      |> expect(:gets, fn data ->
        send self(), {:gets, data}
        "y"
      end)
      Messages.bot_query()
      assert_received {:gets, "Are you playing with a friend? (y/n) "}
    end

    test "should return {:ok, :no_bot} when user enters 'y'"
    do
      expected = {:ok, :no_bot}
      IOMock
      |> expect(:gets, fn _data ->
        "y\n"
      end)
      assert Messages.bot_query() == expected
    end

    test "should return :with_bot when user enters 'n'"
    do
      expected = {:ok, :with_bot}
      IOMock
      |> expect(:gets, fn _data ->
        "N\n"
      end)
      assert Messages.bot_query() == expected
    end

    test "should return {:error, 'enter y or n'} for invalid input" do
      IOMock
      |> expect(:gets, fn _ -> "invalid input" end)

      assert {:error, "enter y or n"} = Messages.bot_query()
    end
  end

  describe "marker_query/1" do
    test "should ask user which marker do they want to play as" do
      IOMock
      |> expect(:gets, fn data ->
        send self(), {:gets, data}
        ""
      end)
      msg = "Would you like to choose your own marker? (y/n) "
      Messages.marker_query(msg)
      assert_received {:gets, ^msg}
    end

    test "should return {:ok, :pass} if user enters 'n'" do
      IOMock
      |> expect(:gets, fn _ -> "N\n" end)
      assert {:ok, :rand_marker} = Messages.marker_query("custom msg")
    end

    test "should return {:ok, :marker_prompt}" do
      IOMock
      |> expect(:gets, fn _ -> "y\n" end)
      assert {:ok, :custom_marker} = Messages.marker_query("custom msg")
    end

    test "should return {:error, 'enter y or n'} for invalid input" do
      IOMock
      |> expect(:gets, fn _ -> "invalid input" end)
      assert {:error, "enter y or n"} = Messages.marker_query("custom msg")
    end
  end

  describe "marker_prompt/1" do
    setup do
      markers = Application.fetch_env!(:tic_tac_toe, :markers)
      msg = "Enter the number of the marker you would like to use: "
      {:ok, markers: markers, custom_msg: msg}
    end

    test "should print out marker previews" ,
    %{markers: markers, custom_msg: msg}
    do
      IOMock
      |> expect(:puts, length(markers), fn data ->
        send self(), {:puts, data}
        :ok
      end)
      |> expect(:gets, fn _ -> "1" end)
      {:ok, markers: markers}

      Messages.marker_prompt(markers, msg, :with_prev)

      [{_, m1}, {_, m2}] = markers

      expected1 = m1.preview() <> "1\n"
      expected2 = m2.preview() <> "2\n"

      assert_received {:puts, ^expected1}
      assert_received {:puts, ^expected2}
    end

    test "should ask user to enter in a choice",
    %{markers: markers, custom_msg: msg}
    do
      expected = {:ok, "1"}
      IOMock
      |> expect(:gets, fn data ->
        send self(), {:gets, data}
        "1"
      end)
      |> expect(:puts, length(markers), fn _ -> :ok end)

      received = Messages.marker_prompt(markers, msg, :with_prev)

      assert_received {:gets, "Enter the number of the marker you would like to use: "}
      assert received == expected
    end

    test "should return error tuple for invalid input",
    %{markers: markers, custom_msg: msg}
    do
      expected = {:error, "enter a number between 1 and 2"}
      IOMock
      |> expect(:puts, length(markers), fn _ -> :ok end)
      |> expect(:gets, fn _ -> "invalid input"end)

      received = Messages.marker_prompt(markers, msg, :with_prev)

      assert received == expected
    end

    test "should not print previews if :no_preview is given",
    %{markers: markers, custom_msg: msg}
    do
      expected = {:ok, "2"}
      IOMock
      |> expect(:gets, fn data ->
        send self(), {:gets, data}
        "2"
      end)

      received = Messages.marker_prompt(markers, msg, :no_prev)

      assert received == expected
    end

  end

  defp win_msg_player1 do
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

  defp win_msg_player2 do
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



    """
  end
end
