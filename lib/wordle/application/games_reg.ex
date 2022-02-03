defmodule Wordle.Application.GameReg do
  @moduledoc """
  Track processes and match them to a specific game
  """
  alias Elixir.Registry

  @doc "To be used in a supervisor to start the registry"
  def specifications, do: {Registry, [keys: :unique, name: __MODULE__]}

  @doc """
  Find a process owned by a specific game
  """
  def via_game_reg(game_id, name), do: {:via, Registry, {__MODULE__, {game_id, name}}}

  def get_repo(game_id), do: via_game_reg(game_id, Wordle.Application.Repository)
end
