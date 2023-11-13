
# config/rpi0.exs

# TODO: come back, rename the "gpio-led0" led to something more specific since we will have color groups
config :delux_demo,
  indicators = %{
    default: %{red: "rgb-red0", green: "rgb-green0", blue: "rgb-blue-"},
    rgb1: %{red: "rgb-red", green: "rgb-green", blue: "rgb-blue"}
  }
