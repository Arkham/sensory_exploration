defmodule Led do
  @delay 200

  def start_link do
    {:ok, pid} = Gpio.start_link(17, :output)
    loop(pid)
  end

  def loop(pid) do
    :timer.sleep(@delay)
    IO.puts "Led on..."
    Gpio.write(pid, 0)

    :timer.sleep(@delay)
    IO.puts "...Led off"
    Gpio.write(pid, 1)
    loop(pid)
  end
end
