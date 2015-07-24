Fox
===

My collection of utility functions I find helpful in day-to-day web programming with Elixir.

> This is alpha software! Use at your own peril!

#### DictExt
`reject_blank_keys/1` : removes all the keys from a dict that are "blank" in the web json sense
```elixir
%{dog: 1, cat: "", bat: [], swede: nil} |> reject_blank_keys
# %{dog: 1, bat: []}
```

#### FunctionExt
`compose/2` : the function version of elixir's `|>`, useful for building pipes with reduces
```elixir
eat = fn girl -> girl |> Italy.eat("carbs") end
pray = fn girl -> girl |> Budan.pray_to("buddha") end
love = fn girl -> girl |> USA.love("white guy") end

live_like_hipster = [eat, pray, love] |> Enum.reduce(&compose/2)
```

#### IntegerExt
`alphabetize/1` : an alternative to `str |> Integer.to_string(26)`, except instead of going 0 to 9, then 'a' to 'p', it just goes from a to z
```elixir
1341 |> alphabetize
```

#### RecordExt
`just_id/1` : takes a record and returns its `id` if the record is present and it's loaded
`just_ids/1` : takes an array of records, and feeds them through `just_id/1`
```elixir
just_id(%User{id: 3}) # 3
just_id(%Ecto.Association.NotLoaded{}) # nil
just_ids([%User{id: 3}]) # [3]
just_ids([%User{id: 3}, %Ecto.Association.NotLoaded{}, %User{id: 5}]) # [3, nil, 5]
just_ids(%Ecto.Association.NotLoaded{}) # nil
```

#### StringExt
`to_url/1` : takes a string and makes it look permalink-like
```elixir
"Breaking! Are 50% of Americans trying to kill you?"
|> to_url
# "breaking-bang-are-50-percent-of-americans-trying-to-kill-you-question"
```

#### TimeExt
`parse/1` : takes a string and attempts to parse it into a Ecto.DateTime regardless of its format (work in progress)

## TODOs

1. Write actual tests
2. Give more parse formats to TimeExt
3. Get rid of Ecto.DateTime in favor of just using Timex