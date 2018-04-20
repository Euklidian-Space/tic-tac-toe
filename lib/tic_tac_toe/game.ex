defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game, Rules, Coordinate}
  @enforce_keys [:board, :rules]
  defstruct [:board, :rules]

  def start_link() do
    Agent.start_link(fn ->
      {:ok, game} = new()
      game
    end)
  end

  def start_game(game) when is_pid(game) do
    %Game{rules: rules} = current_state = get_state(game)
    {:ok, rules} = Rules.check(rules, :add_player)
    new_state = update_game(game, current_state, [rules: rules])
    {:ok, new_state, game}
  end

  def place_mark(game, x, y)
  when is_integer(x) and is_integer(y) and is_pid(game) do

    with {:ok, win_or_not, %Game{} = game_state}
           <- do_place_mark(game, x, y),
         {:ok, %Game{rules: sm} = game_state}
           <- chk_win(game_state, win_or_not)
    do
      case sm.state do
        :game_over ->
          new_state =
            update_game(game, game_state, [rules: sm])
          {:ok, new_state, game}

        _otherwise -> control_to_player2(game_state, game)
      end
    end

  end

  defp new() do
    {:ok, board} = Board.new()
    {
      :ok,
      %Game{
        board: board,
        rules: Rules.new()
      }
    }
  end

  defp get_state(game) when is_pid(game), do:
    Agent.get(game, &(&1))

  defp update_game(game, %Game{} = current_state, updates) do
    new_state = struct(current_state, updates)
    Agent.update(game, fn %Game{} ->
      new_state
    end)
    new_state
  end

  defp do_place_mark(game, x, y) do
    game_state = get_state(game)
    with {:ok, coord} <- Coordinate.new(x, y),
         {:ok, win_or_not, board}
           <- Board.place_mark(game_state.board, :x, coord)
    do
      new_game_state = %Game{game_state | board: board}
      {:ok, win_or_not, new_game_state}
    end
  end

  defp chk_win(%Game{rules: sm} = game_state, :win) do
    with {:ok, rules} <- Rules.check(sm, {:chk_win, :win}),
    do: {:ok, %Game{game_state | rules: rules}}
  end

  defp chk_win(%Game{rules: sm} = game_state, :no_win) do
    with {:ok, rules} <- Rules.check(sm, {:chk_win, :no_win}),
    do: {:ok, %Game{game_state | rules: rules}}
  end

  defp next_player(%Game{rules: sm} = current_game_state, game) do
    case sm.state do
      :player1_turn -> control_to_player2(current_game_state, game)
      :player2_turn -> control_to_player1(current_game_state, game)
    end
  end

  defp control_to_player2(%Game{rules: sm} = game_state, game)
  when is_pid(game) do
    with {:ok, new_rules} <- Rules.check(sm, {:mark, :player1})
    do
      new_state =
        update_game(game, game_state, [rules: new_rules])
      {:ok, new_state, game}
    else
      :error -> {:error, "The turn belongs to player 2."}
    end
  end


end
