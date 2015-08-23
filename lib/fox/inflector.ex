defmodule Fox.Inflector do
  defstruct plural_rules: [], 
    single_rules: [], 
    single_irregulars: %{}, 
    plural_irregulars: %{}, 
    uncountables: []

  def singularize(%{single_rules: rules, single_irregulars: irregulars, uncountables: uncountables}, string) do
    singular_form = apply_special_rules(string, uncountables, irregulars) || apply_rules(string, rules)
    case singular_form do
      nil -> string
      x -> x
    end
  end

  def pluralize(%{plural_rules: rules, plural_irregulars: irregulars, uncountables: uncountables}, string) do
    plural_form = apply_special_rules(string, uncountables, irregulars) || apply_rules(string, rules)
    case plural_form do
      nil -> string
      x -> x
    end
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

  defp apply_rules(string, rules) do
    case rules |> Enum.find(&matches_rule(&1, string)) do
      {regex, replacement} -> string |> String.replace(regex, replacement)
      _ -> nil
    end
  end

  defp matches_rule({regex, _}, string) do
    regex |> Regex.match?(string)
  end

  defp apply_special_rules(string, uncountables, dict) do
    cond do
      string in uncountables -> string
      Dict.has_key?(dict, string) -> dict |> Dict.fetch!(string)
      true -> nil
    end
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
    single_irregulars = inflector.single_irregulars |> Dict.put(single, plural)
    plural_irregulars = inflector.plural_irregulars |> Dict.put(plural, single)
    %{inflector | single_irregulars: single_irregulars, plural_irregulars: plural_irregulars}
  end

  defp uncountable(inflector, strings) when is_list(strings) do
    strings |> Enum.reduce(inflector, &uncountable(&2, &1))
  end

  defp uncountable(inflector, string) when is_binary(string) do
    uncountables = inflector.uncountables
    %{inflector | uncountables: [string|uncountables]}
  end
end