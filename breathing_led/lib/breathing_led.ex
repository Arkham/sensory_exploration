defmodule BreathingLed do
  def start_link do
    {:ok, pid} = Gpio.start_link(17, :output)
    loop(pid)
  end

  def loop(pid) do
    steps = :lists.seq(0, 100, 5)

    set_pwm_and_sleep = fn step ->
      set_pwm(step)
      :timer.sleep(50)
    end

    steps |> Enum.each(set_pwm_and_sleep)

    :timer.sleep(1000)

    steps |> Enum.reverse |> Enum.each(set_pwm_and_sleep)

    :timer.sleep(1000)

    loop(pid)
  end

  defp set_pwm(duty_cycle) when duty_cycle >= 0 and duty_cycle <= 100 do
    # using https://github.com/sarfata/pi-blaster/ to control PWM
    :os.cmd(to_char_list("echo '17=#{duty_cycle/100}' > /dev/pi-blaster"))
  end
end
