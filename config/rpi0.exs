
# config/rpi0.exs

# TODO: come back, rename the "gpio-led0" led to something more specific since we will have color groups
config :delux_demo,
  indicators: %{
    default: %{blue: "gpio-led0"}
  }
