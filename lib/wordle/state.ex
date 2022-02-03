defmodule Wordle.State do
  defstruct [:solution, attempted_words: %{}, remaining_attempts: 6, status: :new, game_id: nil]

  @adjectiv ~w(incredible super quiet dolce small big ludicrous obnoxious)
  @animal ~w(unicorn squirrel horse pig cat dog owl fish eagle fox crow)
  @colors ~w(red blue green white black yellow purple orange pink)

  defp pop_random(list), do: list |> Enum.take_random(1) |> hd

  defp generate_game_id,
    do: "#{pop_random(@colors)}-#{pop_random(@animal)}-#{pop_random(@adjectiv)}"

  def new(word), do: %__MODULE__{game_id: generate_game_id(), solution: word}

  def change(state, changes),
    do: Enum.reduce(changes, state, fn change, state -> _change(state, change) end)

  defp _change(state, {:status, status}), do: Map.put(state, :status, status)

  defp _change(state, {:remaining_attempts, :decrement}),
    do: Map.update(state, :remaining_attempts, 6, fn count -> count - 1 end)

  defp _change(state, {:attempted_words, {word, result}}) do
    Map.update(state, :attempted_words, %{word => result}, fn attempts ->
      Map.put(attempts, word, result)
    end)
  end
end
