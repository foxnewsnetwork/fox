defmodule Fox.TimeExt do

  def american_like?(string) do
    ~r/^\d{4}\-\d{2}-\d{2}$/ |> Regex.match?(string)
  end
  def parse_american(string) do
    string
    |> Timex.DateFormat.parse("{YYYY}-{0M}-{0D}")
    |> (fn {_, timedate} -> timedate end).()
    |> timex_to_ecto_datetime
  end
  def parse(string) do
    cond do
      american_like?(string) -> parse_american(string)
      true -> parse_iso(string)
    end
  end

  def parse_iso(string) do
    string
    |> Timex.DateFormat.parse("{ISO}")
    |> (fn {_, timedate} -> timedate end).()
    |> timex_to_ecto_datetime
  end

  @spec time_ago(integer, atom) :: Ecto.DateTime
  def time_ago({amount, unit}), do: time_ago(amount, unit)
  def time_ago(amount, unit) do
    Ecto.DateTime.utc
    |> subtract(amount, unit)
  end

  @spec time_from_now(integer, atom) :: Ecto.DateTime
  def time_from_now({amount, unit}), do: time_from_now(amount, unit)
  def time_from_now(amount, unit) do
    Ecto.DateTime.utc
    |> add(amount, unit)
  end

  @spec add(Ecto.DateTime, integer, atom) :: Ecto.DateTime
  def add(datetime, integer, unit) do
    datetime
    |> ecto_datetime_to_timex
    |> Timex.Date.shift([{unit, integer}])
    |> timex_to_ecto_datetime
  end

  @spec subtract(Ecto.DateTime, integer, atom) :: Ecto.DateTime
  def subtract(datetime, integer, unit) do
    add(datetime, -integer, unit)
  end

  @spec timex_to_ecto_datetime(Timex.DateTime) :: Ecto.DateTime
  def timex_to_ecto_datetime(timedate) do
    timedate
    |> timex_to_erl
    |> Ecto.DateTime.from_erl
  end

  @spec timex_to_erl(Timex.DateTime) :: {{integer, integer, integer}, {integer, integer, integer}}
  def timex_to_erl(timedate) do
    timedate
    |> Timex.Date.universal
    |> timex_utc_to_erl
  end

  @spec ecto_datetime_to_timex(Ecto.DateTime) :: Timex.DateTime
  def ecto_datetime_to_timex(datetime) do
    datetime
    |> Ecto.DateTime.to_erl
    |> Timex.Date.from
  end


  defp timex_utc_to_erl(%Timex.DateTime{year: year, month: month, day: day, hour: hour, minute: minute, day: day}) do
    {{year, month, day}, {hour, minute, day}}
  end
end