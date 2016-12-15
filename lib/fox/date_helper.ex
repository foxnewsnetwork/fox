defmodule DateHelper do

  @doc """
  Converts an Elixir/Ecto date to common EU string format (dd/mm/yyyy).
  """
  def date_to_text(date) do
    "#{date}"
    |> String.split("-")
    |> Enum.reverse()
    |> Enum.join("/")
  end

  @doc """
  Converts an (dd/mm/yyyy) to an Elixir Date
  """
  def text_to_date(date) do
    date
    |> String.split("/")
    |> Enum.reverse()
    |> Enum.join("-")
    |> Date.from_iso8601!
  end
end
