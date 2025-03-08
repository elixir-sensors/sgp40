# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
# SPDX-FileCopyrightText: 2025 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule SGP40.Comm do
  @moduledoc false

  alias SGP40.Calc

  @cmd_measure_raw <<0x26, 0x0F>>
  @cmd_measure_test <<0x28, 0x0E>>
  @cmd_get_serial_id <<0x36, 0x82>>
  @cmd_get_featureset <<0x20, 0x2F>>

  @transport_mod Application.compile_env(:sgp40, :transport_mod, SGP40.Transport.I2C)

  @spec serial_id(any) :: {:ok, binary} | {:error, any()}
  def serial_id(transport) do
    case @transport_mod.write_read(transport, @cmd_get_serial_id, 3) do
      {:ok, serial_id_binary} -> {:ok, Base.encode16(serial_id_binary)}
      error -> error
    end
  end

  @spec featureset(any) :: {:ok, byte} | {:error, any()}
  def featureset(transport) do
    case @transport_mod.write_read(transport, @cmd_get_featureset, 1) do
      {:ok, <<featureset>>} -> {:ok, featureset}
      error -> error
    end
  end

  @doc """
  Triggers the built-in self-test checking for integrity of both hotplate and MOX material and
  returns the result of this test as 2 bytes (+ 1 CRC byte).
  """
  @spec measure_test(pid) :: {:ok, binary} | {:error, any()}
  def measure_test(transport) do
    with :ok <- @transport_mod.write(transport, @cmd_measure_test),
         :ok <- Process.sleep(250),
         {:ok, <<result::unsigned-16>>} <- @transport_mod.read(transport, 2),
         do: {:ok, result}
  end

  @doc """
  Starts/continues the VOC measurement mode, enables humidity compensation, and returns the
  measured raw signal SRAW as 2 bytes (+ 1 CRC byte). See Sensirion docs:
  * [Data sheet](https://cdn-learn.adafruit.com/assets/assets/000/097/511/original/Sensirion_Gas-Sensors_SGP40_Datasheet.pdf)
  * [Sensirion/embedded-common/sensirion_common.c](https://github.com/Sensirion/embedded-common/blob/1ac7c72c895d230c6f1375865f3b7161ce6b665a/sensirion_common.c)
  * [Sensirion/embedded-sgp/sgp40/sgp40.h](https://github.com/Sensirion/embedded-sgp/blob/00768191892b2cc0d839ebf95998fc4a85b660c4/sgp40/sgp40.h)
  """
  @spec measure_raw_with_rht(pid, number, number) :: {:ok, integer} | {:error, any}
  def measure_raw_with_rht(transport, humidity_rh, temperature_c) do
    h = Calc.humidity_sensor_format(humidity_rh)
    t = Calc.temperature_sensor_format(temperature_c)
    write_read_raw_with_rht_sensor_format(transport, h, t)
  end

  defp write_read_raw_with_rht_sensor_format(transport, h_val, t_val) do
    h_crc = Calc.checksum(<<h_val::16>>)
    t_crc = Calc.checksum(<<t_val::16>>)

    # XX XX XX YY YY YY
    args = <<h_val::unsigned-16, h_crc, t_val::unsigned-16, t_crc>>

    with :ok <- @transport_mod.write(transport, [@cmd_measure_raw, args]),
         :ok <- Process.sleep(250),
         {:ok, <<sraw::unsigned-16>>} <- @transport_mod.read(transport, 2),
         do: {:ok, sraw}
  end
end
