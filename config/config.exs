# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :delux_demo, target: Mix.target()

config :delux,
  indicators: %{
    default: %{green: "rgb-green0", blue: "rgb-blue0", red: "rgb-red0"},
    rgb: %{green: "rgb-green1", blue: "rgb-blue1", red: "rgb-red1"}
  }

config :delux, :dt_overlays,
  overlays_path: "/data/gpio-led.dtbo",
  pins: [
    {"rgb-red0", 12},
    {"rgb-green0", 16},
    {"rgb-blue0", 21},
    {"rgb-red1", 24},
    {"rgb-green1", 25},
    {"rgb-blue1", 1}
  ]

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1698274905"

config :logger, level: :debug, backends: [RingLogger]

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
