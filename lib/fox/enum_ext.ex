defmodule Fox.EnumExt do
    
  @doc """
  Joins the enum with penultimate_joiner until the very end,
  where the joiner is used.

  penultimate_joiner defaults to ", "

  joiner defaults to " and "

  ## Examples

      iex> EnumExt.exford_join(["shoes", "ships", "sealing-wax"])
      "shoes, ships, and sealing-wax"

  """
  @spec oxford_join(Enum.t, String.t, String.t) :: String.t
  def oxford_join(enum, penultimate_joiner\\", ", joiner\\" and ") do
    reduced = Enum.reduce enum, :first, fn
      entry, :first -> {enum_to_string(entry)}
      entry, {prev} -> {:oxford, prev, enum_to_string(entry)}
      entry, {:oxford, acc, prev} -> {[acc, penultimate_joiner|prev], enum_to_string(entry)}
      entry, {acc, prev} -> {[acc, penultimate_joiner|prev], enum_to_string(entry)}
    end
    case reduced do
      :first -> ""
      {ult} -> enum_to_string(ult)
      {:oxford, acc, ult} ->
        IO.iodata_to_binary [acc, joiner, ult]
      {acc, ult} ->
        IO.iodata_to_binary [acc, penultimate_joiner, String.lstrip(joiner)|ult]
    end
  end

  defp enum_to_string(entry) when is_binary(entry), do: entry
  defp enum_to_string(entry), do: String.Chars.to_string(entry)
end