Fox
===

My collection of utility functions I find helpful in day-to-day web programming with Elixir.

#### EnumExt
`oxford_join/3`: similar to `Enum.join/2`, except accounts for the Oxford comma
```elixir
["shoes", "ships", "sealing-wax"]
|> oxford_join(", ", " and ")
# "shoes, ships, and sealing-wax"

["dogs", "cats"]
|> oxford_join(", ", " and ")
# "dogs and cats"
```

#### ListExt
`head/1` : returns everything except the last member of a list
```elixir
[1,2,3] |> head
# [1,2]
[] |> head
# []
```

`tail/1` : returns everything except the first member of a list
```elixir
[1,2,3] |> tail
# [2,3]
```

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

`fmt/2` : Takes a template string and fills it in with stuff in the tuple
```elixir
"customers/:custmer_id/cards/:id" |> fmt({"cus_666", "car_616"})
# customers/cus_666/cards/car_616
```

#### DictExt
`reject_blank_keys/1` : removes all the keys from a dict that are "blank" in the web json sense.
```elixir
%{dog: 1, cat: "", bat: [], swede: nil} |> reject_blank_keys
# %{dog: 1, bat: []}
```

`shallowify_keys/1` : Takes a dict with possibly many levels of embedded dicts, and puts it into a one-level deep list with string keys. Super useful for simplifying form data so HTTPoison / Hackney can consume.

For example:
```elixir
dict = %{
  dog: "rover", 
  cats: ["mrmittens", "fluffmeister"], 
  mascots: %{ember: "hamster", go: "gopher"}
}
dict |> shallowify_keys
# [{"dog", "rover"}, {"cats[]", "mrmittens"}, {"cats[]", "fluffmeister"}, {"mascots[ember]", "hamster"}, {"mascots[go]", "gopher"}]
```

#### MapExt
`present_update/3` : Runs the update function if and only if the map already has the given key.
```elixir
%{dog: 1, cat: 2} |> present_update(:dog, &(&1 + 1))
# %{dog: 2, cat: 2}

%{dog: 1, cat: 3} |> present_update(:serenade, &(&1 * &1))
# %{dog: 1, cat: 3}
```

`present_put/3` : Puts the given value to map if and only if the value isn't one of the following: `nil`, `""`, nil, `%{}`
```elixir
%{dog: 1} |> present_put(:cat, %{})
%{dog: 1}

%{dog: 1} |> present_put(:cat, 1)
%{dog: 1, cat: 1}
```

`value_map/2` : Maps over just the value of your map while keeping all the keys the same
```elixir
%{dog: 1, cat: 2} |> value_map(&(&1 + 2))
# %{dog: 3, cat: 4}
```

#### FunctionExt
`compose/2` : the function version of elixir's `|>`, useful for building pipes with reduces
```elixir
eat = fn girl -> girl |> Italy.eat("carbs") end
pray = fn girl -> girl |> Budan.pray_to("buddha") end
love = fn girl -> girl |> USA.love("white guy") end

live_like_hipster = [eat, pray, love] |> Enum.reduce(&compose/2)
```

#### ParExt
`|>/2` : The parallel pipe, it runs things in parallel. Handy for communicating with multiple external services that don't depend on each other. Consider the example:
```elixir
{heroku_app_id, stripe_customer_id} |> {Hexoku.Api.Apps.get, Stripex.Customers.retrieve}
# {%Hexoku.App{...}, %Stripex.Customer{...}}

# equivalent to the following:
task1 = Task.async(fn -> Hexoku.Api.Apps.get(heroku_app_id) end)
task2 = Task.async(fn -> Stripex.Customes.retrieve(stripe_customer_id) end)
{Task.await(task1), Task.await(task2)}
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

`view_for_model/1` : for some inexplicable reason, Phoenix took this function out in 0.14 and beyond, but it's back here. Takes the module name, appends view to it, and returns the atom. Blows up the view doesn't exist
```elixir
some_model = %MyApp.User{id: 4, username: "william"}
some_model |> view_for_model # MyApp.UserView
```

#### StringExt
`camelize/1` : camel cases a string
```elixir
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
```

`underscore/1` : underscores a string
```elixir
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
```

`dasherize/1` : dasherizes a string
```elixir
"CamelCase" |> dasherize
# camel-case

"AcronymHIV" |> dasherize
# acronym-hiv

"under_score" |> dasherize
# under-score

# Spaces are ignored (following rails convention)
"regular words" |> dasherize
# regular words

"MyApp.Module.SubModule" |> dasherize
# my-app/module/sub-module
```

`singularize/1` : takes an English word and returns its singular form (sorry, only English support for now)
```elixir
"dogs" |> singularize # dog
"oxen" |> singularize # ox
```

`pluralize/1`: takes an English word and returns its plural form.
```elixir
"black" |> pluralize # blacks
"white" |> pluralize # whites
```

>note: it's possible to extend the inflector to include more words, take a look at `config/test.exs` to see an example. Your extensions take precedence over the inflections that ship with the Fox inflector


`consume/2` : takes a string and a token string and attempts to consume the token from the string from the left. Very useful when inferring model / view names from a controller.
```elixir
"dog food" |> consume("dog ")
# {:ok, "food"}

"dog food" |> consume("cat")
# {:error, "no cat in dog food"}
```

`reverse_consume/2` : same as the, except consumes from the right end
```elixir
"namae no nai kaibutsu" |> reverse_consume("kaibutsu")
# {:ok, "namae no nai "}

"namae no nai kaibutsu" |> reverse_consume("dumb show")
# {:error, _}
```

`next_grapheme/2` : just like String.next_grapheme, except if you give it the :reverse atom, it goes backwards
```elixir
"極彩色" |> next_grapheme(:reverse)
# {"極彩", "色"}
```

`integer?/1` : checks if a string can be parsed into an integer

`float?/1` : checks if a string can be parsed into a float

`number?/1` : checks if a string can be parsed as either a float or an integer

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

#### AtomExt
`infer_model_module/1` : Takes a controller module and attempts to infer its model module name. 
  Will error if not given a controller module or the model doesn't exist.

```elixir
MyApp.PictureController |> infer_model_module
# MyApp.Picture
```

`infer_model_key/1` : Takes a controller module and attempts to infer the underscored atom key of its model. Will throw error if not given a controller or the model doesn't exist
```elixir
MyApp.PictureController |> infer_model_key
# :picture

MyApp.DonkeyPunchController |> infer_model_key
# :donkey_punch
```

`infer_collection_key/1` : Takes a controller module and attempts to infer the underscored atom key of its model's collection. Throws error if not given a controller or the model doesn't exist.
```elixir
MyApp.PictureController |> infer_model_key
# :pictures

MyApp.DonkeyPunchController |> infer_model_key
# :donkey_punches
```

#### TimeExt
TimeExt has been removed since Elixir 1.3 will now ship with DateTime in the language core
## TODOs

1. Write actual tests
2. Give more parse formats to TimeExt
3. Get rid of Ecto.DateTime in favor of just using Timex