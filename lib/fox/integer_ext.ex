defmodule Fox.IntegerExt do
  @alphabet "abcdefghijklmnopqrstuvwxyz"
  def alphabetize(0), do: "a"
  def alphabetize(nil), do: "a"
  def alphabetize(n) when n < 0 do 
    n |> abs |> alphabetize("-")
  end
  def alphabetize(n), do: alphabetize(n, "")
  def alphabetize(0, str), do: str
  def alphabetize(n, x) do
    nex = (n / 26) |> trunc
    rem = n |> rem(26)
    char = @alphabet |> String.at(rem)
    alphabetize(nex, x <> char)
  end

end