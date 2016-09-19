defmodule Alarm do
  use Application

  @timeout 100
  @laser_pin 17
  @buzzer_pin 18

  def start(_, _) do
    {:ok, laser} = Gpio.start_link(@laser_pin, :output)
    Gpio.write(laser, 0)

    {:ok, buzzer} = Gpio.start_link(@buzzer_pin, :output)
    Gpio.write(buzzer, 1)

    {:ok, sensors} = I2c.start_link("i2c-1", 0x48)

    loop(%{buzzer: buzzer, sensors: sensors})
  end

  def loop(%{buzzer: buzzer, sensors: sensors} = state) do
    :timer.sleep(@timeout)

    value = read_sensor(sensors, 0)

    if value > 100 do
      IO.puts "light: intruder! (value #{value})"
      Gpio.write(buzzer, 0)
      loop(state)
    end

    value = read_sensor(sensors, 1)

    if value < 110 do
      IO.puts "temperature: intruder! (value #{value})"
      Gpio.write(buzzer, 0)
      loop(state)
    end

    value = read_sensor(sensors, 2)

    if value < 110 do
      IO.puts "sound: intruder! (value #{value})"
      Gpio.write(buzzer, 0)
      loop(state)
    end

    # no alarm failing
    Gpio.write(buzzer, 1)

    loop(state)
  end

  defp read_sensor(pid, channel) do
    {channel_value, _} = Integer.parse("#{channel + 40}", 16)
    I2c.write(pid, <<channel_value>>)
    I2c.read(pid, 1)
    <<value>> = I2c.read(pid, 1)
    value
  end
end
