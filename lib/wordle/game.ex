defmodule Wordle.Game do
  alias Wordle.State

  def try_word(word, state) do
    play({:try_word, word}, state)
  end

  defp compute_word(word, solution) when is_binary(word) or is_binary(solution),
    do: compute_word(String.to_charlist(word), String.to_charlist(solution))

  defp compute_word(word, solution) do
    word
    |> Enum.zip(solution)
    |> Enum.map(fn {letter, expected_letter} ->
      compute_letter(letter, expected_letter, solution)
    end)
    |> List.to_tuple()
  end

  defp compute_letter(letter, expected_letter, _) when letter == expected_letter, do: :good

  defp compute_letter(letter, _, solution),
    do: if(Enum.member?(solution, letter), do: :misplaced, else: :bad)

  defp play(input, state) do
    case {input, state} do
      {_, %{status: final_state} = state} when final_state in [:victory, :defeat] ->
        {final_state, :already_ended, state}

      {{:compute_result, {:good, :good, :good, :good, :good}}, state} ->
        {:victory, :word_found, State.change(state, %{status: :victory})}

      {{:compute_result, _}, state} ->
        {:ongoing, :wait_for_input, state}

      {_, state = %{remaining_attempts: 0}} ->
        {:defeat, :no_more_attempts, State.change(state, %{status: :defeat})}

      {{:try_word, word}, state = %{solution: solution}} ->
        result = compute_word(word, solution)

        state =
          State.change(state, %{
            remaining_attempts: :decrement,
            attempted_words: {word, result},
            status: :ongoing
          })

        play({:compute_result, result}, state)
    end
  end
end
