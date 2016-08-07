defmodule LedButton do
  def start_link do
    {:ok, button_pid} = Gpio.start_link(18, :input)
    {:ok, led_pid} = Gpio.start_link(17, :output)
    Gpio.set_int(button_pid, :both)
    loop(button_pid, led_pid)
  end

  def loop(button_pid, led_pid) do
    receive do
      {:gpio_interrupt, 18, :falling} ->
        IO.puts "led off.."
        Gpio.write(led_pid, 1)
        loop(button_pid, led_pid)
      {:gpio_interrupt, 18, :rising} ->
        IO.puts "..led on"
        Gpio.write(led_pid, 0)
        loop(button_pid, led_pid)
    end
  end
end
