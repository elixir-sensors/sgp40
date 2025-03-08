# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule SGP40.Transport do
  @moduledoc false

  defstruct [:ref, :bus_address]

  @type t :: %__MODULE__{ref: reference(), bus_address: 0..127}
  @type option :: {:bus_name, String.t()} | {:bus_address, 0..127}

  @callback open([option()]) :: {:ok, t()} | {:error, any()}

  @callback read(t(), pos_integer()) :: {:ok, binary()} | {:error, any()}

  @callback write(t(), iodata()) :: :ok | {:error, any()}

  @callback write_read(t(), iodata(), pos_integer()) :: {:ok, binary()} | {:error, any()}
end

defmodule SGP40.Transport.I2C do
  @moduledoc false

  @behaviour SGP40.Transport

  @impl SGP40.Transport
  def open(opts) do
    bus_name = Access.fetch!(opts, :bus_name)
    bus_address = Access.fetch!(opts, :bus_address)

    case Circuits.I2C.open(bus_name) do
      {:ok, ref} ->
        {:ok, %SGP40.Transport{ref: ref, bus_address: bus_address}}

      _ ->
        :error
    end
  end

  @impl SGP40.Transport
  def read(transport, bytes_to_read) do
    Circuits.I2C.read(transport.ref, transport.bus_address, bytes_to_read)
  end

  @impl SGP40.Transport
  def write(transport, register_and_data) do
    Circuits.I2C.write(transport.ref, transport.bus_address, register_and_data)
  end

  @impl SGP40.Transport
  def write_read(transport, register, bytes_to_read) do
    Circuits.I2C.write_read(transport.ref, transport.bus_address, register, bytes_to_read)
  end
end

defmodule SGP40.Transport.Stub do
  @moduledoc false

  @behaviour SGP40.Transport

  @impl SGP40.Transport
  def open(_opts), do: {:ok, %SGP40.Transport{ref: make_ref(), bus_address: 0x00}}

  @impl SGP40.Transport
  def read(_transport, _bytes_to_read), do: {:ok, "stub"}

  @impl SGP40.Transport
  def write(_transport, _data), do: :ok

  @impl SGP40.Transport
  def write_read(_transport, _data, _bytes_to_read), do: {:ok, "stub"}
end
