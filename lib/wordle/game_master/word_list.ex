defmodule Wordle.GameMaster.WordList do
  def create(words) when is_list(words) do
    Stream.zip(days(), acceptable_words(words))
  end

  def create(words, split_on \\ " ") when is_binary(words),
    do: create(String.split(words, split_on))

  defp acceptable_words(words) do
    words
    |> Stream.filter(&(String.length(&1) == 5))
    |> Stream.map(&String.downcase/1)
  end

  defp days() do
    Stream.iterate(Date.utc_today(), &Date.add(&1, 1))
  end
end
