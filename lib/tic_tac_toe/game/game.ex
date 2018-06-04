defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game, Rules, Coordinate}
  @enforce_keys [:board, :rules]
  defstruct [:board, :rules, :winner, :name]
  @behaviour TicTacToe.GameBehaviour
  use GenServer

  @type t :: __MODULE__

  #Public API

  def start_link(name, board_size \\ 3) when is_binary(name), do:
    GenServer.start_link(__MODULE__, [name: name, board_size: board_size])

  def start_game(game), do:
    GenServer.call(game, :start_game)

  def place_mark(game, {x, y} = mark)
  when is_pid(game) and is_number(x) and is_number(y),
  do: GenServer.call(game, {:place_mark, mark})

  ##GenServer Callbacks

  def init(opts) do
    name = Keyword.fetch!(opts, :name)
    board_size = Keyword.fetch!(opts, :board_size)
    {:ok, new(name, board_size)}
  end

  def handle_call(:start_game, _from, %Game{rules: rules} = state_data) do
    {:ok, rules} = Rules.check(rules, :add_player)
    new_state = %Game{state_data | rules: rules}
    reply_success(new_state, :ok)
  end

  def handle_call({:place_mark, {x, y}}, _from, %Game{} = state_data) do
    with {:ok, win_or_not, new_state_data}
           <- do_place_mark(state_data, x, y),
         {:ok, new_state_data}
           <- chk_win(new_state_data, win_or_not)
    do
      # case rules.state do
      #   :game_over ->
      # end
      reply_success(new_state_data, {:ok, new_state_data})
    else
      err -> reply_error(state_data, err)
    end
  end

  ##private helper functions

  defp new(name, board_size) do
    {:ok, board} = Board.new(board_size)
    %Game{
      board: board,
      rules: Rules.new(),
      winner: nil,
      name: name
    }
  end

  defp reply_success(state_data, reply), do: {:reply, reply, state_data}

  defp reply_error(state_data, err), do: {:reply, err, state_data}

  defp do_place_mark(%Game{} = game_state, x, y) do
    with {:ok, coord} <- Coordinate.new(x, y),
         {:ok, win_or_not, board}
           <- Board.place_mark(game_state.board, get_marker(game_state), coord)
    do
      {:ok, new_rules} = Rules.check(game_state.rules, :mark)
      {:ok, win_or_not, %Game{game_state | board: board, rules: new_rules}}
    end
  end

  defp chk_win(%Game{rules: rules} = game_state, :win) do
    with {:ok, new_rules} <- Rules.check(rules, {:chk_win, :win})
    do
      winner = get_winner(rules.state)
      new_state = %Game{game_state | rules: new_rules, winner: winner}
      {:ok, new_state}
    end
  end

  defp chk_win(%Game{rules: rules} = game_state, :no_win) do
    with {:ok, rules} <- Rules.check(rules, {:chk_win, :no_win}),
    do: {:ok, %Game{game_state | rules: rules}}
  end

  defp chk_win(%Game{rules: rules} = game_state, :tie) do
    with {:ok, rules} <- Rules.check(rules, {:chk_win, :tie}),
    do: {:ok, %Game{game_state | rules: rules}}
  end

  defp get_marker(%Game{rules: rules}) do
    case rules.state do
      :player1_turn -> :x
      :player2_turn -> :o
    end
  end

  defp get_winner(:player1_turn), do: :player2
  defp get_winner(:player2_turn), do: :player1

end
