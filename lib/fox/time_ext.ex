defmodule Fox.TimeExt do
  alias Timex.DateFormat
  
  @time_formats [
    iso8601: {~r/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/, "{ISO}"},
    iso: {~r/^\d{4}-\d{2}-\d{2}$/, "{YYYY}-{0M}-{0D}"},
    rfc1123: {~r/^\w{3}, \d{2} \w{3} \d{4} \d{2}:\d{2}:\d{2} [\+\-]\d{4}$/, "{RFC1123}"},
    rfc1123: {~r/^\w{3}, \d{2} \w{3} \d{4} \d{2}:\d{2}:\d{2} \w{3}$/, "{RFC1123}"},
    amerifat: {~r/^\d{2}\/\d{2}\/\d{4}$/, "{0M}/{0D}/{YYYY}"},
    american: {~r/^\d{2}\/\d{2}\/\d{2}$/, "{0M}/{0D}/{YY}"},
  ]
  def parse!(whatever) do
    case whatever |> parse do
      {:ok, time} -> time
      {:error, error} -> throw error
    end
  end

  def parse({{_,_,_}, {_,_,_}}=erl_datetime) do
    {:ok, erl_datetime |> Timex.Date.from}
  end
  def parse(%Ecto.DateTime{}=datetime) do
    time = datetime 
    |> Ecto.DateTime.to_erl
    |> Timex.Date.from
    {:ok, time}
  end
  def parse(string) when is_binary(string) do
    case string |> parse_known_formats do
      {:ok, time} -> {:ok, time}
      {:error, error} -> {:error, error}
      nil -> {:error, "I can't parse the following into a datetime: #{string}"}
    end
  end

  defp parse_known_formats(string) do
    format = @time_formats
    |> Enum.map(&elem(&1, 1))
    |> Enum.find(&matches_format?(&1, string))

    case format do
      {_regex, form} -> string |> DateFormat.parse(form)
      _ -> nil
    end
  end

  defp matches_format?({regex, _form}, string) do
    regex |> Regex.match?(string)
  end


end