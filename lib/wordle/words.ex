defmodule Wordle.Words do
  @list %{
    ~D[2022-02-02] => "house",
    ~D[2022-02-03] => "corky",
    ~D[2022-02-04] => "rusty"
  }

  def pick(date = %Date{}), do: Map.get(@list, date, :no_word_for_date)
end
