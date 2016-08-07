defmodule RgbLed do
  @colors ["#000000", "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#FFFFFF"]

  def start_link do
    # run sudo ./pi-blaster --gpio 17,18,19
    {:ok, red_pid} = Gpio.start_link(17, :output)
    {:ok, green_pid} = Gpio.start_link(18, :output)
    {:ok, blue_pid} = Gpio.start_link(19, :output)
    loop()
  end

  def loop do
    @colors |> Enum.each(fn color ->
      %{red: red, green: green, blue: blue} = ColorUtils.hex_to_rgb(color)
      set_pwm(17, red/255.0)
      set_pwm(18, green/255.0)
      set_pwm(19, blue/255.0)
      :timer.sleep(500)
    end)
    loop
  end

  defp set_pwm(gpio, ratio) when ratio >= 0 and ratio <= 1 do
    # using https://github.com/sarfata/pi-blaster/ to control PWM
    :os.cmd(to_char_list("echo '#{gpio}=#{ratio}' > /dev/pi-blaster"))
  end
end
