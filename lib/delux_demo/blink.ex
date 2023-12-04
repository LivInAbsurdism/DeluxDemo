defmodule DeluxDemo.Blink do
  use GenServer
  require Logger
  alias Delux, as: D

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def handle_cast({:button_press_count, count}, state) do
    case count do
      1 ->
        render_patterns(pattern_for_single_press(), :user_feedback)

      2 ->
        render_patterns(pattern_for_double_press(), :user_feedback)

      3 ->
        # Higher slot
        render_patterns(pattern_for_triple_press(), :user_feedback)
        # Lower slot
        render_patterns(pattern_for_status(), :status)

      4 ->
        render_patterns(pattern_for_quad_press(), :user_feedback)

      _ ->
        Logger.info("Unhandled press count: #{count}")
    end

    {:noreply, state}
  end

  defp pattern_for_single_press() do
    Logger.debug("single press triggered")
    %{default: D.Effects.on(:magenta), rgb: D.Effects.on(:magenta)}
  end

  defp pattern_for_double_press() do
    Logger.debug("double press triggered")
    %{default: D.Effects.on(:magenta), rgb: D.Effects.on(:cyan)}
  end

  defp pattern_for_triple_press() do
    Logger.debug("triple press triggered")
    %{default: D.Effects.on(:yellow), rgb: D.Effects.on(:yellow)}
  end

  defp pattern_for_quad_press() do
    Logger.debug("quad press, lights off")
    %{default: D.Effects.off(), rgb: D.Effects.off()}
  end

  defp pattern_for_status() do
    Logger.debug("status pattern triggered")
    %{default: D.Effects.on(:blue), rgb: D.Effects.on(:yellow)}
  end

  defp render_patterns(patterns, slot) do
    D.render(patterns, slot)
  end
end
