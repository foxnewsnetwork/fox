use Mix.Config
config :fox, :inflections,
  plural: {~r/(黒)$/, "\\1猫"},
  plural: {~r/44$/, "forty-four"},
  singular: {~r/(君の翔)ぶ空$/, "\\1"},
  irregular: {"染", "somaru"},
  uncountable: "doge"
