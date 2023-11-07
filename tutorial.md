TODO: edit all of this 

## Configuring an rpi0 for use with Delux
See nerves docs [here](https://hexdocs.pm/nerves/installation.html).
See delux docs [here](https://hexdocs.pm/delux/readme.html). 

To begin, create a basic nerves project and install on your `rpi0`.
`mix nerves.new delux_demo`
`cd delux_demo`
`export MIX_TARGET=rpi0`
`mix deps.get`


### Building the circuit
I started with one LED connected to one of my GPIO pins to keep it simple. We can add more as we work through configuring Delux. 
TODO: maybe elaborate on this depending on how good you want the tutorial to be
TODO: Add photo here

### Verifying your circuit works
- Verify your circuit works by adding Circuits.GPIO as a dependency and turning the circuit on and off (or you can just power it some other way and make sure the LED turns on).
- To test with Circuits.GPIO, you'll need to build the firmware, burn it to your SD, and boot up your pi
- SSH in or connect to your `rpi0` and verify that it's working using Circuits.GPIO. 

### Setting up the project, dependencies, and the rpi0
- Add Delux as a dependency 
- Add a `config.exs` file for your `rpio`

``` elixir
config :delux_demo,
  indicators: %{
    default: %{led_color: "#{led_name}"}
  }
```

- Set up the Application Supervisor. 
For just one LED, we can start with a simple Delux child process in our supervision tree. Set it up, along with your indicators in the start function. 
``` elixir
 indicators = %{
      default: %{blue: "gpio-led0"}
    }
    children =
      [
        {Delux, name: Delux, indicators: indicators}
      ]
```

### Setting up the device tree overlay and compiling to device tree blob
Nerves Advance Configuration doc https://github.com/nerves-project/nerves/blob/main/docs/Advanced%20Configuration.md#device-tree-overlays

https://www.youtube.com/watch?v=m_NyYEBxfn8

Device Tree for dummies 
TODO: format these as additional learning resources

In order to set our GPIO pin as an LED, we need to set up a device tree overlay to tell the system how to interact with hardware at a low level. The device tree (put link to device tree docs here) is a data structure that describes the hardware components so that the operating system's kernel can use and manage those components. 

The device tree overlay allows us to modify the tree without having to reocmpile it entirely. Here, we use the device tree overlay to ensure that when the system boots up, it knows that the specified GPIO pin should be controlled as an LED. This setup allows higher-level abstractions like Delux to interact with the LED through simple interfaces without handling the underlying hardware complexities. 

If you are not using an `rpi0`, these instructions are going to be slightly different in regards to setting up your overlay. I found it useful to look at the source code for the Nerves system for the `rpi0` as well as the base device tree source for your specific device (for the rpi0, it is here https://github.com/raspberrypi/linux/blob/rpi-4.19.y/arch/arm/boot/dts/bcm2708-rpi-zero.dts). 

This provides some insight into what the device tree overlay will need to look like and between the source, nerves docs, and the source code for the nerves system, I was able to parse together how to set up my own custom device tree overlay. 

1. Set up your .dts file 
TODO: surely best practice says it should go somewhere that makes sense / isn't /config. Circle back to me. 
TODO: Also, there may even be a cleaner way to to this overlay. Ask an adultier adult. 
For the `rpi0`, we can start with something like this (link the .dts file)
Note, whatever you label the led here is what we will use to reference it in the rest of the Nerves project. 
You'll want to update the name with the name used here in the `application.ex`

Once that's been set up, we will want to compile it down to a blob. 
`dtc -@ -I dts -O dtb -o name_of_file.dtbo name_of_file.dts`. 

This will create the device tree blob overlay. 

### Adding to the fwup.conf file and setting up config.txt
Next, we will need to set up a custom `fwup.conf` file and point Nerves to use it. Note, this will overwrite the original `fwup.conf` file so you'll either want to import it into your custom file or copy it in from the Nerves System for your hardware. Add your customizations to this file. 

You'll also want to pull the `config.txt` to add your customizations to it. Along with the pre-existing overlays in the `config.txt`, you can add yours like so `dtoverlay=name_of_overlay`. You'll reference this in the `fwup.conf` so set it up first. 

I added the following to my `fwup.conf`.

```
file-resource gpio_led.dtbo {
    host-path = "${NERVES_APP}/config/gpio_led.dtbo"
}

file-resource config.txt {
    host-path = "${NERVES_APP}/config/config.txt"
}

on-resource gpio_led.dtbo { fat_write(${BOOT_A_PART_OFFSET}, "/overlays/gpio_led.dtbo")}
on-resource gpio_led.dtbo { fat_write(${BOOT_A_PART_OFFSET}, "/overlays/gpio_led.dtbo")}
```
These were added to the already existing structure in the file. See (LINK) for exactly where they're located in the file. 

To use your custom `fwup.conf`, add `fwup_conf: path_to_fwup.conf` to your `config.exs` for the nerves config. 

TODO: link to your fwup.conf and the original from the nerves system for rpi0 




### Configuring with Application Supervisor
TODO: probably don't need this
As mentioned earlier, if you haven't already, update your LED name with the name you set in the device tree overlay in your application supervisor. 


### Adding additional LEDs to the circuit

### Configuring those LEDs

### TBD (make some sort of lil program)

### End Goal 
- 3 groups of LEDs that blink in sequence (blue, red, yellow, etc)
- thorough explanation of editing the device tree since there are very few online rn