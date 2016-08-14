defmodule WavyMotor do
  def start_link do
    {:ok, pin1} = Gpio.start_link(17, :output)
    {:ok, pin2} = Gpio.start_link(18, :output)
    {:ok, enable} = Gpio.start_link(27, :output)

    Gpio.write(pin1, 1)
    Gpio.write(pin2, 0)

    loop(enable)
  end

  def loop(enable) do
    steps = [0 | :lists.seq(40, 100, 10)]

    set_pwm_and_sleep = fn step ->
      set_pwm(step)
      :timer.sleep(200)
    end

    steps |> Enum.each(set_pwm_and_sleep)
    steps |> Enum.reverse |> Enum.each(set_pwm_and_sleep)
    steps |> Enum.each(set_pwm_and_sleep)
    steps |> Enum.reverse |> Enum.each(set_pwm_and_sleep)
    steps |> Enum.each(set_pwm_and_sleep)
    steps |> Enum.reverse |> Enum.each(set_pwm_and_sleep)
    :timer.sleep(5000)

    loop(enable)
  end

  defp set_pwm(duty_cycle) when duty_cycle >= 0 and duty_cycle <= 100 do
    # using https://github.com/sarfata/pi-blaster/ to control PWM
    :os.cmd(to_char_list("echo '27=#{duty_cycle/100}' > /dev/pi-blaster"))
  end
end
