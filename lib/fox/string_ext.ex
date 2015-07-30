defmodule Fox.StringExt do
  @character_map %{
    "%" => "percent",
    "#" => "hashtag",
    "@" => "at",
    "?" => "question",
    "!" => "bang",
    "&" => "and",
    "*" => "star",
    "/" => "slash",
    "\\" => "backslash",
    "\"" => "quote",
    "'" => "quote",
    "," => "comma",
    "." => "period",
    "+" => "plus"
  }


  @doc """
  Takes a string and builds it into an url-friendly string,
  good for permalinks and generally being passed around in the browser
  """
  def to_url(nil), do: nil
  def to_url(string) do
    string
    |> String.downcase
    |> transformations.()
    |> String.replace(~r/\s+$/, "")
    |> String.replace(~r/\s+/, "-")
    |> String.replace(~r/[^a-zA-Z0-9\-_]/, "")
  end

  @doc """
  Generates a random string of length n. Defaults to n = 10
  """
  def random, do: random(10)  
  def random(n) do
    if is_integer(n) and n >= 0 do
      rand("", n)
    else
      raise "#{n} is not a non-negative integer"
    end
  end

  @url_alphabet "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  @ua_length String.length(@url_alphabet)
  defp rand(str, -1), do: str
  defp rand(str, n) do
    i = :random.uniform(@ua_length)
    char = @url_alphabet |> String.at(i)
    rand("#{str}#{char}", n - 1)
  end


  def transformations, do: @character_map |> Enum.map(&transformify(&1)) |> Enum.reduce(&Fox.FunctionExt.compose/2)
  def transformify({pattern, replacement}) do
    &String.replace(&1, pattern, " #{replacement} ")
  end
end