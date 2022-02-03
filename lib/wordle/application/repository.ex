defmodule Wordle.Application.Repository do
  use Agent
  import Wordle.Application.GameReg
  require Logger

  def start_link(initial_state = %Wordle.State{game_id: id}),
    do: Agent.start_link(fn -> initial_state end, name: via_game_reg(id, __MODULE__))

  def update(repository, new_state = %Wordle.State{}),
    do: Agent.update(repository, fn _ -> new_state end)

  def get(repository), do: Agent.get(repository, & &1)

  def terminate(_reason, _state),
    do: Logger.info("Terminating state. Would be a good time to persist data in a filesytem")
end
