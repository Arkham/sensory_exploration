defmodule RotaryEncoder do
  def start_link do
    {:ok, pid0} = Gpio.start_link(17, :input)
    {:ok, pid1} = Gpio.start_link(18, :input)
    Gpio.set_int(pid0, :both)
    Gpio.set_int(pid1, :both)
    loop(false, false, 0)
  end

  def loop(pid0_status, pid1_status, current_value) do
    receive do
      {:gpio_interrupt, 17, :falling} ->
        if pid0_status == false && pid1_status == false do
          current_value = current_value + 1
          IO.puts "Current value is #{current_value}"
        end
        loop(true, pid1_status, current_value)
      {:gpio_interrupt, 17, :rising} ->
        loop(false, pid1_status, current_value)
      {:gpio_interrupt, 18, :falling} ->
        if pid0_status == false && pid1_status == false do
          current_value = current_value - 1
          IO.puts "Current value is #{current_value}"
        end
        loop(pid0_status, true, current_value)
      {:gpio_interrupt, 18, :rising} ->
        loop(pid0_status, false, current_value)
    end
  end
end
