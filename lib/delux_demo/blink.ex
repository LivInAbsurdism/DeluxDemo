defmodule DeluxDemo.Blink do
    @moduledoc """
      Module for controlling the pattern of the LEDs.
    """
    use GenServer
    require Logger

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec set_mode(non_neg_integer()) :: :ok
  def set_mode(count) do
    IO.puts("COUNT IS #{count}")
    GenServer.call(DeluxDemo.Blink, {:button_press_count, count}, 10000)
  end

  @impl GenServer
  def init(_args) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:button_press_count, count}, _from, state) do
    count |> pattern_for_mode() |> render_patterns(:user_feedback)

    {:reply, :ok, state}
  end

  defp pattern_for_mode(1) do
    Logger.debug("single press triggered")
    %{default: Delux.Effects.on(:magenta), rgb: Delux.Effects.on(:magenta)}
  end

  defp pattern_for_mode(2) do
    Logger.debug("double press triggered")
    %{default: Delux.Effects.on(:magenta), rgb: Delux.Effects.on(:cyan)}
  end

  defp pattern_for_mode(3) do
    Logger.debug("triple press triggered")
    %{default: Delux.Effects.on(:yellow), rgb: Delux.Effects.on(:yellow)}
  end

  defp pattern_for_mode(4) do
    Logger.debug("quad press, lights off")
    %{default: Delux.Effects.off(), rgb: Delux.Effects.off()}
  end

  defp pattern_for_mode(_mode), do: %{default: Delux.Effects.off(), rgb: Delux.Effects.off()}

  defp pattern_for_status() do
    Logger.debug("status pattern triggered")
    %{default: Delux.Effects.on(:blue), rgb: Delux.Effects.on(:yellow)}
  end

  defp render_patterns(patterns, slot) do
    Delux.render(patterns, slot)
  end
end
