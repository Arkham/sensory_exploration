defmodule Motor do
  def start_link do
    {:ok, pin1} = Gpio.start_link(17, :output)
    {:ok, pin2} = Gpio.start_link(18, :output)
    {:ok, enable} = Gpio.start_link(27, :output)

    loop(pin1, pin2, enable)
  end

  def loop(pin1, pin2, enable) do
    Gpio.write(enable, 1)
    Gpio.write(pin1, 1)
    Gpio.write(pin2, 0)
    :timer.sleep(5000)

    Gpio.write(enable, 0)
    :timer.sleep(5000)

    Gpio.write(enable, 1)
    Gpio.write(pin1, 0)
    Gpio.write(pin2, 1)
    :timer.sleep(5000)

    Gpio.write(enable, 0)
    :timer.sleep(5000)

    loop(pin1, pin2, enable)
  end
end
