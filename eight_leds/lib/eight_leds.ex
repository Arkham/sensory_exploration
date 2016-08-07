defmodule EightLeds do
  @gpio_pins [17, 18, 19, 20, 21, 22, 23, 24]
  @delay 50

  def start_link do
    pids = @gpio_pins |> Enum.map(fn pin ->
      {:ok, pid} = Gpio.start_link(pin, :output)
      Gpio.write(pid, 1)
      pid
    end)
    loop(pids)
  end

  def loop(pids) do
    Enum.each(pids, fn pid ->
      Gpio.write(pid, 0)
      :timer.sleep(100)
      Gpio.write(pid, 1)
    end)
    loop(pids)
  end
end
