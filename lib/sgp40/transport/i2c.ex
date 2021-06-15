defmodule SGP40.Transport.I2C do
  @moduledoc false

  @behaviour SGP40.Transport

  @type bus_name :: binary
  @type bus_address :: 0..127
  @type transport :: pid
  @type register :: non_neg_integer()

  @impl SGP40.Transport
  @spec start_link(bus_name: bus_name, bus_address: bus_address) ::
          {:ok, transport} | {:error, any}
  def start_link(opts) do
    transport_module().start_link(opts)
  end

  @impl SGP40.Transport
  @spec read(transport, integer) ::
          {:ok, binary} | {:error, any}
  def read(transport, bytes_to_read) do
    transport_module().read(transport, bytes_to_read)
  end

  @impl SGP40.Transport
  @spec write(transport, iodata) ::
          :ok | {:error, any}
  def write(transport, register_and_data) do
    transport_module().write(transport, register_and_data)
  end

  @impl SGP40.Transport
  @spec write(transport, register, iodata) ::
          :ok | {:error, any}
  def write(transport, register, data) do
    transport_module().write(transport, register, data)
  end

  @impl SGP40.Transport
  @spec write_read(transport, register | iodata, integer) ::
          {:ok, binary} | {:error, any}
  def write_read(transport, register, bytes_to_read) do
    transport_module().write_read(transport, register, bytes_to_read)
  end

  defp transport_module() do
    Application.get_env(:sgp40, :transport_module, I2cServer)
  end
end
