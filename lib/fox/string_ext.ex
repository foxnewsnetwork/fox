defmodule Fox.StringExt do

  alias Fox.Inflector
  @inflector Inflector.inflections
  @doc """
  Takes a string and makes it camel-cased.
  Note that "/" become periods "."

  ## Examples
    "under_scored" |> camelize
    # UnderScored
  
    # acronyms are not restored by camelize (lol obviously)
    "acronym_hiv" |> camelize
    # AcronymHiv 
    
    # spaces are ignored
    "sakidasu kasa no mure ni" |> camelize
    # Sakidasu kasa no mure ni

    "my_app/module/sub_module" |> camelize
    # MyApp.Module.SubModule
  """
  def camelize(string) do
    string
    |> String.split("/")
    |> Enum.map(&dumb_capitalize/1)
    |> Enum.join(".")
    |> String.split("_")
    |> Enum.map(&dumb_capitalize/1)
    |> Enum.join("")
  end
  defp dumb_capitalize(""), do: ""
  defp dumb_capitalize(str) when is_binary(str) do
    {s, tr} = str |> String.next_grapheme
    String.capitalize(s) <> tr
  end

  @doc """
  Takes a string and makes it underscored. This is the semi-inverse of camelize.
  Note that because this is Elixir and not ruby, periods become "/", not "::"

  ## Examples
    "CamelCase" |> underscore
    # camel_case

    "AcronymHIV" |> underscore
    # acronym_hiv

    "dasher-ized" |> underscore
    # dasher_ized

    # Spaces are ignored (following rails convention)
    "regular words" |> underscore
    # regular words

    "MyApp.Module.SubModule" |> underscore
    # my_app/module/sub_module
  """
  @lower_case ~r/[a-z0-9]/
  @upper_case ~r/[A-Z]/
  def underscore(string) do
    "" |> underscore(string)
  end
  defp underscore(output, ""), do: output
  defp underscore(output, original) do
    {grapheme, remaining} = original |> String.next_grapheme
    {lookahead, _} = remaining |> String.next_grapheme || {"", ""}

    translation = cond do
      grapheme == "." -> 
        "/"
      grapheme == "-" ->
        "_"
      grapheme =~ @lower_case and lookahead =~ @upper_case ->
        grapheme <> "_"
      grapheme =~ @upper_case ->
        String.downcase(grapheme)
      true ->
        grapheme
    end
    underscore(output <> translation, remaining)
  end

  @doc """
  Takes a string and makes it dashed, very similar to underscore, except
  instead of "_" we use "-"

  ### Examples
    "CamelCase" |> dasherize
    # camel-case

    "AcronymHIV" |> dasherize
    # acronym-hiv

    "dasher-ized" |> dasherize
    # dasher-ized

    # Spaces are ignored (following rails convention)
    "regular words" |> dasherize
    # regular words

    "MyApp.Module.SubModule" |> dasherize
    # my-app/module/sub-module
  """
  def dasherize(string) do
    string
    |> underscore
    |> String.replace("_", "-")
  end

  @doc """
  Takes a word and returns its singular form

  ## Examples
    "dogs" |> singularize # dog
    "oxen" |> singularize # ox

    "App.Something.DumbChildren" |> singularize
    # "App.Something.DumbChild"

    "App.Something.DumbChildRen" |> singularize
    # "App.Something.DumbChildRen"
  """
  def singularize(nouns) do
    @inflector |> Inflector.singularize(nouns)
  end

  @doc """
  Takes a singular word and returns the plural form

  ## Examples
    "black" |> pluralize # blacks
    "white" |> pluralize # whites

    "App.Something.DumbChild" |> pluralize
    # "App.Something.DumbChildren"

    "App.Something.DumbChildRen" |> pluralize
    # "App.Something.DumbChildRens"

  Note that in the last example, random capitalization
  will induce the inflector to treat ChildRen as 2 words.
  This is intentionally different from ActiveSupport's version.
  """
  def pluralize(noun) do
    @inflector |> Inflector.pluralize(noun)
  end

  @doc """
  Takes a string consume from the left a portion of the string and returns the remaining string 

  ## Examples
    "dog food" |> consume("dog ")
    # {:ok, "food"}
    
    "dog food" |> consume("cat")
    # {:error, "no cat in dog food"}
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

  @doc """
  Same as `consume/2`, except throws error instead of returning a tuple
  """
  def consume!(meal, bite) do
    case meal |> consume(bite) do
      {:ok, leftover} -> leftover
      {:error, error} -> throw error
    end
  end

  @doc """
  Consumes a string starting from the end and going to the begining.

  ## Examples
    "namae no nai kaibutsu" |> reverse_consume("kaibutsu")
    # {:ok, "namae no nai "}

    "namae no nai kaibutsu" |> reverse_consume("dumb show")
    # {:error, _}
  """
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

  @doc """
  Same as `reverse_consume/2` except returns values/throws error instead of returning tuple
  """
  def reverse_consume!(meal, bite) do
    case meal |> reverse_consume(bite) do
      {:ok, leftover} -> leftover
      {:error, error} -> throw error
    end
  end

  @doc """
  Just like `String.next_grapheme/1`, except if you give it the `:reverse` atom, it goes backwards

  ## Examples
    "極彩色" |> next_grapheme(:reverse)
    # {"極彩", "色"}
  """
  def next_grapheme(string), do: String.next_grapheme(string)
  def next_grapheme(string, :reverse) do
    g = String.last(string)
    strin = string |> String.slice(0..-2)
    {strin, g}
  end
  def next_grapheme(string, _), do: next_grapheme(string)

  @int_exp ~r/^-?\d+$/
  @doc """
  returns true if a string can be parsed as an integer
  """
  def integer?(string) do
    @int_exp |> Regex.match?(string)
  end

  @float_exp ~r/^-?\d*\.\d+$/
  @doc """
  returns true if a string can be parsed as an float
  """
  def float?(string) do
    @float_exp |> Regex.match?(string)
  end

  @doc """
  returns true if a string can be parsed as an integer or float
  """
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
  ## Examples
    "Breaking! Are 50% of Americans trying to kill you?"
    |> to_url
    # "breaking-bang-are-50-percent-of-americans-trying-to-kill-you-question"
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
  
  ## Examples
    random(33) 
    # dv9hUn7rfnKOtLkOebBkfaUEmWMND522V
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