defmodule Fox.Inflector do
  defstruct plural_rules: [], 
    single_rules: [],
    irregulars: [],
    uncountables: []

  def singularize(%{single_rules: rules, irregulars: irregulars, uncountables: uncountables}, string) do
    singular_form = apply_rules(string, uncountables) || 
      apply_irregular_singles(string, irregulars) || 
      apply_rules(string, rules)
    case singular_form do
      nil -> string
      x -> x
    end
  end

  def pluralize(%{plural_rules: rules, irregulars: irregulars, uncountables: uncountables}, string) do
    plural_form = apply_rules(string, uncountables) ||
      apply_irregular_plurals(string, irregulars) || 
      apply_rules(string, rules)
    case plural_form do
      nil -> string
      x -> x
    end
  end

  defp apply_rules(string, rules) do
    case rules |> Enum.find(&matches_rule(&1, string)) do
      uncountable when is_binary(uncountable) -> 
        string
      {regex, replacement} -> 
        string |> String.replace(regex, replacement)
      _ -> nil
    end
  end

  defp matches_rule(uncountable, string) when is_binary(uncountable) do
    alias Fox.StringExt, as: S
    case string |> S.reverse_consume(uncountable) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
  defp matches_rule({gobi, _}, string) when is_binary(gobi) do
    alias Fox.StringExt, as: S
    case string |> S.reverse_consume(gobi) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
  defp matches_rule({regex, _}, string) do
    regex |> Regex.match?(string)
  end

  defp matches_irregular_gobi({gobi, _replacement}, string) do
    case string |> Fox.StringExt.reverse_consume(gobi) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  defp matches_irregular_repl({gobi, replacement}, string) do
    matches_irregular_gobi({replacement, gobi}, string)
  end

  defp try_irregular_gobi(string, irregulars) do
    case irregulars |> Enum.find(&matches_irregular_gobi(&1, string)) do
      {gobi, replacement} ->
        string
        |> Fox.StringExt.reverse_consume!(gobi)
        |> Kernel.<>(replacement)
      _ -> nil
    end
  end

  defp try_irregular_repl(string, irregulars) do
    case irregulars |> Enum.find(&matches_irregular_repl(&1, string)) do
      {_, _} -> string
      _ -> nil
    end
  end

  defp apply_irregular_singles(string, irregulars) do
    irregulars = irregulars |> Enum.map(fn {a,b} -> {b,a} end)
    try_irregular_gobi(string, irregulars) || try_irregular_repl(string, irregulars)
  end

  defp apply_irregular_plurals(string, irregulars) do
    try_irregular_repl(string, irregulars) || try_irregular_gobi(string, irregulars)
  end

  defp plural(inflector, regex, replacement) do
    plural_rules = [{regex, replacement} | inflector.plural_rules]
    %{inflector | plural_rules: plural_rules}
  end

  defp singular(inflector, regex, replacement) do
    single_rules = [{regex, replacement} | inflector.single_rules]
    %{inflector | single_rules: single_rules}
  end

  defp irregular(inflector, single, plural) do
    r1 = {dumb_decapitalize(single), dumb_decapitalize(plural)}
    r2 = {dumb_capitalize(single), dumb_capitalize(plural)}
    rules = if r1 == r2, do: [r1], else: [r1, r2]
    %{inflector | irregulars: rules ++ inflector.irregulars}
  end

  defp uncountable(inflector, strings) when is_list(strings) do
    strings |> Enum.reduce(inflector, &uncountable(&2, &1))
  end

  defp uncountable(inflector, string) when is_binary(string) do
    r1 = dumb_decapitalize(string)
    r2 = dumb_capitalize(string)
    rules = if r1 == r2, do: [r1], else: [r1, r2]
    %{inflector | uncountables: rules ++ inflector.uncountables}
  end

  defp dumb_decapitalize(""), do: ""
  defp dumb_decapitalize(str) when is_binary(str) do
    {s, tr} = str |> String.next_grapheme
    String.downcase(s) <> tr
  end

  defp dumb_capitalize(""), do: ""
  defp dumb_capitalize(str) when is_binary(str) do
    {s, tr} = str |> String.next_grapheme
    String.capitalize(s) <> tr
  end

  defp apply_environment_inflections(inflector) do
    Application.get_env(:fox, :inflections, [])
    |> Enum.reduce(inflector, &apply_config_inflections/2)
  end
  defp apply_config_inflections({:plural, {regex, replacement}}, inflector) do
    inflector |> plural(regex, replacement)
  end
  defp apply_config_inflections({:singular, {regex, replacement}}, inflector) do
    inflector |> singular(regex, replacement)
  end
  defp apply_config_inflections({:irregular, {single, plural}}, inflector) do
    inflector |> irregular(single, plural)
  end
  defp apply_config_inflections({:uncountable, word}, inflector) do
    inflector |> uncountable(word)
  end

  def inflections do
    %Fox.Inflector{}
    |> plural(~r/$/, "s")
    |> plural(~r/s$/i, "s")
    |> plural(~r/^(ax|test)is$/i, "\\1es")
    |> plural(~r/(octop|vir)us$/i, "\\1i")
    |> plural(~r/(octop|vir)i$/i, "\\1i")
    |> plural(~r/(alias|status)$/i, "\\1es")
    |> plural(~r/(bu)s$/i, "\\1ses")
    |> plural(~r/(buffal|tomat)o$/i, "\\1oes")
    |> plural(~r/([ti])um$/i, "\\1a")
    |> plural(~r/([ti])a$/i, "\\1a")
    |> plural(~r/sis$/i, "ses")
    |> plural(~r/(?:([^f])fe|([lr])f)$/i, "\\1\\2ves")
    |> plural(~r/(hive)$/i, "\\1s")
    |> plural(~r/([^aeiouy]|qu)y$/i, "\\1ies")
    |> plural(~r/(x|ch|ss|sh)$/i, "\\1es")
    |> plural(~r/(matr|vert|ind)(?:ix|ex)$/i, "\\1ices")
    |> plural(~r/^(m|l)ouse$/i, "\\1ice")
    |> plural(~r/^(m|l)ice$/i, "\\1ice")
    |> plural(~r/^(ox)$/i, "\\1en")
    |> plural(~r/^(oxen)$/i, "\\1")
    |> plural(~r/(quiz)$/i, "\\1zes")

    |> singular(~r/s$/i, "")
    |> singular(~r/(ss)$/i, "\\1")
    |> singular(~r/(n)ews$/i, "\\1ews")
    |> singular(~r/([ti])a$/i, "\\1um")
    |> singular(~r/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i, "\\1sis")
    |> singular(~r/(^analy)(sis|ses)$/i, "\\1sis")
    |> singular(~r/([^f])ves$/i, "\\1fe")
    |> singular(~r/(hive)s$/i, "\\1")
    |> singular(~r/(tive)s$/i, "\\1")
    |> singular(~r/([lr])ves$/i, "\\1f")
    |> singular(~r/([^aeiouy]|qu)ies$/i, "\\1y")
    |> singular(~r/(s)eries$/i, "\\1eries")
    |> singular(~r/(m)ovies$/i, "\\1ovie")
    |> singular(~r/(x|ch|ss|sh)es$/i, "\\1")
    |> singular(~r/^(m|l)ice$/i, "\\1ouse")
    |> singular(~r/(bus)(es)?$/i, "\\1")
    |> singular(~r/(o)es$/i, "\\1")
    |> singular(~r/(shoe)s$/i, "\\1")
    |> singular(~r/(cris|test)(is|es)$/i, "\\1is")
    |> singular(~r/^(a)x[ie]s$/i, "\\1xis")
    |> singular(~r/(octop|vir)(us|i)$/i, "\\1us")
    |> singular(~r/(alias|status)(es)?$/i, "\\1")
    |> singular(~r/^(ox)en/i, "\\1")
    |> singular(~r/(vert|ind)ices$/i, "\\1ex")
    |> singular(~r/(matr)ices$/i, "\\1ix")
    |> singular(~r/(quiz)zes$/i, "\\1")
    |> singular(~r/(database)s$/i, "\\1")

    |> irregular("person", "people")
    |> irregular("man", "men")
    |> irregular("child", "children")
    |> irregular("sex", "sexes")
    |> irregular("move", "moves")
    |> irregular("zombie", "zombies")

    |> uncountable(~w(equipment information rice money species series fish sheep jeans police))
    |> apply_environment_inflections
  end
end