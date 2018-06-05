defmodule TicTacToe.GameSupervisor do 
  use Supervisor
  alias TicTacToe.Game

  #Public API
    
  def start_link(_opts), do:
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  #Supervisor callbacks

  def init(:ok), do:
    Supervisor.init([Game], strategy: :simple_one_for_one)     
  
  def start_game(name), do: 
    Supervisor.start_child(__MODULE__, [name])

  def stop_game(name), do:
    Supervisor.terminate_child(__MODULE__, pid_from_name(name))

  #Private helper functions
  
  defp pid_from_name(name) do
    name
    |> Game.via_tuple
    |> GenServer.whereis 
  end 
end 
