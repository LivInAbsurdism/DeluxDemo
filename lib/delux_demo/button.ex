defmodule DeluxDemo.Button do
  use GenServer
  require Logger
  alias Circuits.GPIO

  @input_pin 16
  @press_interval 800  # Time window for button press counting in milliseconds

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, input_gpio} = GPIO.open(@input_pin, :input)
    GPIO.set_interrupts(input_gpio, :both)
    {:ok, %{input_gpio: input_gpio, press_count: 0}}
  end

  def handle_info({:circuits_gpio, _pin, _timestamp, value}, state) do
    case value do
      1 -> Process.send_after(self(), :check_press_count, @press_interval)
            {:noreply, %{state | press_count: state.press_count + 1}}
      0 -> {:noreply, state}
    end
  end

  def handle_info(:check_press_count, %{press_count: count} = state) do
    GenServer.cast(DeluxDemo.Blink, {:button_press_count, count})
    {:noreply, %{state | press_count: 0}}
  end
end
