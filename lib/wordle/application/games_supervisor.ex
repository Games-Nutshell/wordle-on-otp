defmodule Wordle.Application.GameSupervisor do
  use DynamicSupervisor

  alias Wordle.Application.Repository

  def start_link(_), do: DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)

  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  def start_game(word) do
    initial_state = Wordle.State.new(word)
    DynamicSupervisor.start_child(__MODULE__, {Repository, initial_state})
    initial_state
  end
end
