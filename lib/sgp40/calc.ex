defmodule SGP40.Calc do
  @moduledoc false

  import Bitwise

  @doc """
  Convert humidity RH in the format used by the SGP40 sensor.

  ## Examples

      iex> humidity_sensor_format(0)
      0
      iex> humidity_sensor_format(50)
      32763 # approx. 0x8000
      iex> humidity_sensor_format(100)
      65527 # approx. 0xFFFF

  """
  @spec humidity_sensor_format(0..100) :: 0..0xFFFF
  def humidity_sensor_format(humidity_rh) do
    h1000 = trunc(humidity_rh * 1000)

    h1000 =
      cond do
        h1000 < 0 -> 0
        h1000 > 100_000 -> 100_000
        true -> h1000
      end

    (h1000 * 671) >>> 10
  end

  @doc """
  Convert temperature C in the format used by the SGP40 sensor.

  ## Examples

      iex> temperature_sensor_format(-45)
      0
      iex> temperature_sensor_format(25)
      26250 # approx. 0x6666
      iex> temperature_sensor_format(130)
      65535

  """
  @spec temperature_sensor_format(-45..130) :: 0..0xFFFF
  def temperature_sensor_format(temperature_c) do
    t1000 = trunc(temperature_c * 1000)

    t1000 =
      cond do
        t1000 < -45_000 -> -45_000
        t1000 > 129_760 -> 129_760
        true -> t1000
      end

    ((t1000 + 45_000) * 3) >>> 3
  end

  @doc """
  The 8-bit CRC checksum transmitted after each data word. See Sensirion docs:
  * [Data sheet](https://cdn-learn.adafruit.com/assets/assets/000/097/511/original/Sensirion_Gas-Sensors_SGP40_Datasheet.pdf) - Section 4
  * https://github.com/Sensirion/embedded-common/blob/1ac7c72c895d230c6f1375865f3b7161ce6b665a/sensirion_common.c#L60

  ## Examples

      # list of bytes
      iex> checksum([0xBE, 0xEF])
      0x92
      iex> checksum([0x80, 0x00])
      0xA2
      iex> checksum([0x66, 0x66])
      0x93

      # binary
      iex> checksum(<<0xBEEF::16>>)
      0x92
      iex> checksum(<<0x8000::16>>)
      0xA2
      iex> checksum(<<0x6666::16>>)
      0x93

  """
  @spec checksum(binary | list) :: byte
  def checksum(bytes_binary) when is_binary(bytes_binary) do
    bytes_binary |> :binary.bin_to_list() |> checksum()
  end

  def checksum(bytes_list) when is_list(bytes_list) do
    Enum.reduce(bytes_list, 0xFF, &each_byte_crc_reducer/2) &&& 0xFF
  end

  defp each_byte_crc_reducer(byte, acc) do
    Enum.reduce(0..7, bxor(acc, byte), &each_bit_crc_reducer/2)
  end

  defp each_bit_crc_reducer(_bit, acc) do
    case acc &&& 0x80 do
      0 -> acc <<< 1
      _ -> bxor(acc <<< 1, 0x31)
    end
  end
end
