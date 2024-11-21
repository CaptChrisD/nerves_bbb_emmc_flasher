# NervesBbbEmmcFlasher

This Nerves firmware is used to flash BeagleBone Black eMMC. It includes a Nerves `.fw` file that is an "empty" Elixir Application just to get something on the eMMC. Not necessary, but if you would like to change the intial firmware just copy your projects `.fw` file to `./rootfs_overlays/nerves/emmc_firmware.fw`.

## Targets

This project can only target the Beaglebone so you should use `MIX_TARGET=bbb` for all nerves commands.

## How to Flash the eMMC

To start your Nerves app:
  * `export MIX_TARGET=bbb`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an uSD card with `mix burn`
  * Insert the uSD card in BeagleBone
  * Power the BeagleBone while holding down the S2 button.
  * Wait for flashing to complete. Behavior: The leds will have "normal" flashing patterns for a few seconds before going into a sweeping pattern. After the sweeping pattern completes all LEDs will go solid and the Beaglebone will power off.
  * Remove uSD card from BeagleBone
  * Power on the BeagleBone and enjoy!
  * You can now update with OTA methods (eg `mix upload`) with firmware using the [Nerves BBB eMMC System](https://github.com/CaptChrisD/nerves_system_bbb_emmc)

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Elixir Slack #nerves channel: https://elixir-slack.community/
  * Elixir Discord #nerves channel: https://discord.gg/elixir
  * Source: https://github.com/nerves-project/nerves
