defmodule Fox.StringExt do
  alias Fox.Inflector
  @inflector Inflector.inflections

  @doc """
  Takes a word and returns its singular form
  """
  def singularize(nouns) do
    @inflector |> Inflector.singularize(nouns)
  end

  @doc """
  Takes a singular word and returns the plural form
  """
  def pluralize(noun) do
    @inflector |> Inflector.pluralize(noun)
  end

  @doc """
  Takes a string consume from the left a portion of the string and returns the remaining string 
  """
  def consume(meal, ""), do: {:ok, meal}
  def consume(meal, bite) do
    {m, eal} = meal |> String.next_grapheme
    {b, ite} = bite |> String.next_grapheme
    if m == b do
      consume(eal, ite)
    else
      {:error, "expected '#{b}' to equal '#{m}' in '#{meal}'"}
    end
  end

  def consume!(meal, bite) do
    case meal |> consume(bite) do
      {:ok, leftover} -> leftover
      {:error, error} -> throw error
    end
  end

  def reverse_consume(meal, ""), do: {:ok, meal}
  def reverse_consume(meal, bite) do
    {mea, l} = meal |> next_grapheme(:reverse)
    {bit, e} = bite |> next_grapheme(:reverse)

    if l == e do
      reverse_consume(mea, bit)
    else
      {:error, "expected '#{e}' to equal '#{l}' in '#{meal}'"}
    end
  end

  def reverse_consume!(meal, bite) do
    case meal |> reverse_consume(bite) do
      {:ok, leftover} -> leftover
      {:error, error} -> throw error
    end
  end

  def next_grapheme(string), do: String.next_grapheme(string)
  def next_grapheme(string, :reverse) do
    g = String.last(string)
    strin = string |> String.slice(0..-2)
    {strin, g}
  end
  def next_grapheme(string, _), do: next_grapheme(string)

  @int_exp ~r/^-?\d+$/
  def integer?(string) do
    @int_exp |> Regex.match?(string)
  end

  @float_exp ~r/^-?\d*\.\d+$/
  def float?(string) do
    @float_exp |> Regex.match?(string)
  end

  def number?(string) do
    integer?(string) || float?(string)
  end


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