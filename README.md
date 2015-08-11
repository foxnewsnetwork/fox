Fox
===

My collection of utility functions I find helpful in day-to-day web programming with Elixir.

> This is alpha software! Use at your own peril!

#### UriExt
`encode_query/1` : just like `URI.encode_query/1`, except it also encodes embedded lists and maps
```elixir
query = [
  dog: "rover", 
  cats: ["mrmittens", "fluffmeister"], 
  mascots: %{ember: "hamster", go: "gopher"}
] 
query |> encode_query
# dog=rover&cats[]=mrmittens&cats[]=fluffmeister&mascots[ember]=hamster&mascots[go]=gopher
```

`decode_query/1`: the reverse of the above *** NOT IMPLEMENTED YET ***

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

`random/1` : takes an integer and generates a random url-friendly string from it. N defaults to 10. Useful for when you need to quickly generate lengthy tokens, and you don't need the heavy-handed complexity of bcrypt or even sha256
```elixir
random(33) 
# dv9hUn7rfnKOtLkOebBkfaUEmWMND522V
```
Remember, this *is* erlang's `:random.uniform` in the background, and so it's only pseudo-random

### RandomExt
`uniform/1` : just like erlang's `:random.uniform/1` except it messes up the seed first so it doesn't generate the same value each time on process start. Handy for when you need to generate tokens for the database which shouldn't repeat or be trivially predictable (lol the NSA will still crack it though, because this uses :os.timestamp)
```elixir
uniform(11)
# 12345678901
# here you kill your process and restart it
uniform(11)
# 23482323444 
```
Notice that this function goes against everything Erlang stands for in terms of the fail-often-and-restore-state philosophy. Therefore, please know what you're doing before peppering this guy everywhere.

#### TimeExt
`parse/1` : takes a string and attempts to parse it into a Ecto.DateTime regardless of its format (work in progress)


## TODOs

1. Write actual tests
2. Give more parse formats to TimeExt
3. Get rid of Ecto.DateTime in favor of just using Timex