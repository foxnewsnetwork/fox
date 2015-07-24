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

  def transformations, do: @character_map |> Enum.map(&transformify(&1)) |> Enum.reduce(&Fox.FunctionExt.compose/2)
  def transformify({pattern, replacement}) do
    &String.replace(&1, pattern, " #{replacement} ")
  end
end