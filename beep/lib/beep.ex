defmodule Beep do
  def start_link do
    {:ok, pid} = Gpio.start_link(17, :output)
    loop(pid)
  end

  def loop(pid) do
    IO.puts "Buzzer on!"
    Gpio.write(pid, 0)
    :timer.sleep(100)
    IO.puts "Buzzer off"
    Gpio.write(pid, 1)
    :timer.sleep(500)
    loop(pid)
  end
end
