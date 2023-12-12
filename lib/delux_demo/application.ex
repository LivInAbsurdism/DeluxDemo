defmodule DeluxDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    _delux_options = Application.get_all_env(:delux_demo)
    setup_device_tree_overlays()

    indicators = %{
      default: %{green: "rgb-green0", blue: "rgb-blue0", red: "rgb-red0"},
      rgb: %{green: "rgb-green1", blue: "rgb-blue1", red: "rgb-red1"}
    }

    children =
      [
        {Delux, name: Delux, indicators: indicators},
        {DeluxDemo.Blink, []},
        {DeluxDemo.Button, []}
      ]

    opts = [strategy: :one_for_one, name: DeluxDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_device_tree_overlays do
    overlays = [
      ["/data/gpio-led.dtbo", "label=rgb-red0", "gpio=12"],
      ["/data/gpio-led.dtbo", "label=rgb-green0", "gpio=16"],
      ["/data/gpio-led.dtbo", "label=rgb-blue0", "gpio=21"],
      ["/data/gpio-led.dtbo", "label=rgb-red1", "gpio=24"],
      ["/data/gpio-led.dtbo", "label=rgb-green1", "gpio=25"],
      ["/data/gpio-led.dtbo", "label=rgb-blue1", "gpio=1"]
    ]

    Enum.each(overlays, fn args ->
      {output, exit_code} = System.cmd("dtoverlay", args)

      if exit_code != 0 do
        Logger.error("Failed to execute: #{Enum.join(args, " ")}")
        Logger.error("Output: #{output}")
      end
    end)
  end
end
