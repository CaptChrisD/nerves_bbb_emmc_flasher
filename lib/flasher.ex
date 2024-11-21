defmodule NervesBbbEmmcFlasher.Flasher do
  use GenServer
  alias Nerves.Leds
  require Logger

  @led_path "/sys/class/leds/"
  @led_base "beaglebone:green:usr"
  @tick_rate 200

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    Logger.info("Starting Flashing Process")
    init_leds()
    # Wait 10 seconds for system to stabilize
    Logger.info("Waiting for system to stabilize")
    Process.send_after(self(), :start_flash, 10000)
    {:ok, %{led_state: 1}}
  end

  def handle_info(:start_flash, state) do
    Logger.info("Flashing /dev/mmcblk1 with FWUP")
    args = ~w(-a -d /dev/mmcblk1 -i /nerves/emmc_firmware.fw -t complete)
    parent = self()

    Task.async(fn ->
      System.cmd("fwup", args)
      Process.send(parent, :flash_complete, [])
    end)

    {:noreply, state}
  end

  def handle_info(:flash_complete, state) do
    Logger.info("Flash Complete")

    for i <- 0..3 do
      Leds.set(@led_base <> "#{i}", true)
    end

    Process.send_after(self(), :wait_complete, 2000)

    {:noreply, %{state | led_state: :off}}
  end

  def handle_info(:wait_complete, state) do
    Logger.info("Shutting Down System - Remove uSD and reboot device")
    Nerves.Runtime.halt()

    {:noreply, state}
  end

  def handle_info(:led_tick, %{led_state: :off} = state) do
    {:noreply, state}
  end

  def handle_info(:led_tick, %{led_state: led_state} = state) do
    cur_led = led_state
    prev_led = if led_state == 0, do: 3, else: led_state - 1
    Leds.set("beaglebone:green:usr" <> "#{cur_led}", true)
    Leds.set("beaglebone:green:usr" <> "#{prev_led}", false)

    next_led_state = if led_state == 3, do: 0, else: led_state + 1

    {:noreply, %{state | led_state: next_led_state}}
  end

  # handler for async task return
  # TODO: make more robust then just a catch all
  def handle_info(_msg, state) do
    # Logger.info("#{__MODULE__} got a message: #{inspect(msg)}")
    {:noreply, state}
  end

  def init_leds() do
    for i <- 0..3 do
      led = @led_path <> @led_base <> "#{i}/triggers"
      File.write(led, "none")
    end

    Leds.set(@led_base <> "0", true)
    Leds.set(@led_base <> "1", false)
    Leds.set(@led_base <> "2", false)
    Leds.set(@led_base <> "3", false)

    :timer.send_interval(@tick_rate, :led_tick)
  end
end
