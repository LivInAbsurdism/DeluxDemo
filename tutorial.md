# Setting Up an RGB Circuit with Device Tree Overlay for use with Delux

## Introduction

### Goals

- Set up a circuit with two RGB LEDs
- Add a button
- Set the GPIOs to the LEDs
- Control the LEDs using the button and Delux

### Required Materials

- Raspberry Pi Zero
- Two RGB LEDs
- Breadboard
- Six 220 ohm resistors
- One 10k ohm resistor
- One Pushbutton
- Jumper cables

### Part 1: Basic Setup and Single RGB LED Control

#### Setting Up the Development Environment

More info pertaining to Nerves can be found in the [Nerves documentation](https://hexdocs.pm/nerves/installation.html). The Delux documentation can be found [here](https://hexdocs.pm/delux/readme.html).

Install Elixir and Nerves.

To begin, create a basic nerves project and install on your `rpi0`.
I like to set the MIX_TARGET so I don't need to specify the target for all my cmds.

Create a new Nerves project.

``` code
mix nerves.new delux_demo
cd delux_demo
export MIX_TARGET=rpi0
mix deps.get
```

#### Set up Delux

- Add Delux to `mix.exs` and install dependencies.
- Set LED names in your `config.exs` and the dt_overlays path as shown below

``` elixir
 config :delux,
  indicators: %{
    default: %{green: "rgb-green0", blue: "rgb-blue0", red: "rgb-red0"}
  }

config :delux, :dt_overlays,
  overlays_path: "/data/gpio-led.dtbo",
  pins: [
    {"rgb-red0", 12},
    {"rgb-green0", 16},
    {"rgb-blue0", 21},
  ]
```

### Building the First RGB LED Circuit

<img src="./assets/rpi0_pinout.png" width="300" height="300">

Using the pinout diagram, build a circuit for the first RGB LED using the 220 ohm resistors. Make note of each GPIO pin used as they will be referenced later.

<img src="assets/delux_demo_one_led_bb.jpg" width="350" height="300"> <img src="assets/delux_demo_one_led_schematic.jpg" width="450" height="300">

I've used GPIOs 12, 16, and 21 for red, green, and blue.

### Setting the LEDs to GPIO with a pre-existing Device Tree Overlay

- Load the device tree blob object - `gpio-led.dtbo` - to your Raspberry Pi
  - Can be found within nerves artifacts with `find ~/.nerves/artifacts -name "*gpio-led*"`
  - SCP that to your Nerves device.

#### Interacting with the LED in IEx

Now when your Nerves application starts up, your GPIO pins should be named and ready to use with Delux.

At this point, you can test the LEDs with various Delux cmds.

``` elixir
  Delux.render(%{default: Delux.Effects.on(:red)})
```

### Part 2: Add a Second LED and set the GPIOs

<img src="assets/delux_demo_second_led_bb.jpg" width="350" height="300">
<img src="assets/delux_demo_second_led_schematic.jpg" width="450" height="300">

Build the circuit for the second LED.

Add the new set of indicators to your `config.exs` as indicators and pins.
You can now control both sets of indicators in your iEX shell on your device.

``` elixir
Delux.render(%{default: Delux.Effects.on(:magenta), rgb: Delux.Effects.on(:magenta)})
```

### Introducing a Push-Button

Add a push-button to the circuit with a pull-up resistor as shown in the diagram and schematic below.

<img src="assets/delux_demo_final_bb.jpg" width="350" height="300">
<img src="assets/delux_demo_final_schematic.jpg" width="475" height="300">

#### Setting Up GenServers

Now, we'll use two GenServers for sending the button presses to the LEDs. We will also set up Delux to run with the indicators set up on start.

Add each GenServer to the child processes in your Application Supervisor.

``` elixir
    children =
      [
        {DeluxDemo.Blink, []},
        {DeluxDemo.Button, []}
      ]

    opts = [strategy: :one_for_one, name: DeluxDemo.Supervisor]
    Supervisor.start_link(children, opts)
```

Create each GenServer. I called mine `Blink` and `Button`.

#### Blink GenServer

See `blink.ex` for a simple GenServer that receives messages from the `Button` GenServer and renders patterns based on how many button presses occur.
Feel free to change colors, patterns, or slots - note the default slots have a prioritization order and can be overridden by others.

##### Button GenServer

See `button.ex` for the other GenServer. We set up our input pin and monitor it with `Circuits.GPIO` and send the button presses to the `Blink` GenServer.

### Part 3: Bringing It All Together

Build the firmware again and upload it the device.
And there you have it.  You are now controlling LEDs using Delux and your input button.

### Conclusion

Feel free to play with slots in the `Blink` GenServer code to see how they override each other or play with additional `Delux.Effects` in the GenServer. There are many combinations. You can also add additional LEDs to indicators or set up custom slots.
