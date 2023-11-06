# TODO: circle back to this boy once other LEDs are configuredd
##defmodule DeluxDemo.Blink do
#   use GenServer

#   def start_link(_args) do
#     GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
#   end

#   def init(:ok) do
#     {:ok, nil}
#   end

#   def handle_info(:blink, _state) do
#     quick_blink_pattern = Delux.Effects.number_blink(
#     :blue,
#     3,
#     blink_on_duration: 100,
#     blink_off_duration: 100,
#     inter_number_delay: 1000  # 1-second pause between quick and slow blinks
#   )

#   slow_blink_pattern = Delux.Effects.number_blink(
#     :blue,
#     3,
#     blink_on_duration: 500,
#     blink_off_duration: 500
#   )

#   Delux.render(quick_blink_pattern)
#   :timer.sleep(1000 * (3 + 1))
#   Delux.render(slow_blink_pattern)

#   {:noreply, nil}
#   end
# end
