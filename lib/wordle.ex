defmodule Wordle do
  alias Wordle.Application.{GameSupervisor, Repository}

  import Wordle.Application.GameReg

  def start do
    word_of_today = Wordle.Words.pick(Date.utc_today())
    %{game_id: game_id} = GameSupervisor.start_game(word_of_today)
    game_id
  end

  def try_word(game_id, word) do
    state_repo = get_repo(game_id)
    state = Repository.get(state_repo)
    {_, _, new_state} = move_result = Wordle.Game.try_word(word, state)
    Repository.update(state_repo, new_state)

    move_result
  end

  def stop(game_id), do: GenServer.stop(get_repo(game_id))
end
