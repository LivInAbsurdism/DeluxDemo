defmodule DeluxDemo.Button do
  @moduledoc """
    Module for ingesting button presses and sending them to DeluxDemo.Blink
  """
  use GenServer
  alias Circuits.GPIO
  require Logger

  @input_pin 22
  @press_interval 900

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(args) do
    Logger.debug("START LINK BUTTON")
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl GenServer
  def init(_args) do
    Logger.debug("IN INIT FOR BUTTON")
    {:ok, input_gpio} = GPIO.open(@input_pin, :input)
    GPIO.set_interrupts(input_gpio, :both)
    {:ok, %{input_gpio: input_gpio, press_count: 0}}
  end

  @impl GenServer
  def handle_info({:circuits_gpio, _pin, _timestamp, value}, state) do
    case value do
      1 ->
        Process.send_after(self(), :check_press_count, @press_interval)
        {:noreply, %{state | press_count: state.press_count + 1}}

      0 ->
        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_info(:check_press_count, %{press_count: count} = state) do
    DeluxDemo.Blink.set_mode(count)
    {:noreply, %{state | press_count: 0}}
  end
end
