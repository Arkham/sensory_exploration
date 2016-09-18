defmodule Alarm do
  @timeout 200
  @laser_pin 17
  @buzzer_pin 18

  def start_link do
    {:ok, laser} = Gpio.start_link(@laser_pin, :output)
    Gpio.write(laser, 0)

    {:ok, buzzer} = Gpio.start_link(@buzzer_pin, :output)
    Gpio.write(buzzer, 1)

    {:ok, sensor} = I2c.start_link("i2c-1", 0x48)

    loop(%{laser: laser, buzzer: buzzer, sensor: sensor})
  end

  def loop(%{laser: laser, buzzer: buzzer, sensor: sensor} = state) do
    :timer.sleep(@timeout)

    value = read_sensor(sensor)
    if value > 100 do
      IO.puts "intruder!"
      Gpio.write(buzzer, 0)
    else
      IO.puts "all good"
      Gpio.write(buzzer, 1)
    end

    loop(state)
  end

  defp read_sensor(sensor) do
    I2c.read(sensor, 1)
    <<value>> = I2c.read(sensor, 1)
    value
  end
end
