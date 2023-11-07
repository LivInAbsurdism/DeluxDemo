defmodule DeluxDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    _delux_options = Application.get_all_env(:delux_demo)
    indicators = %{
      default: %{blue: "gpio-led0"}
    }
    children =
      [
        {Delux, name: Delux, indicators: indicators}
      ]

    opts = [strategy: :one_for_one, name: DeluxDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
