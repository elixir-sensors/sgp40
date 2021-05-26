defmodule SGP40.Transport.I2C.Stub do
  @moduledoc false

  @behaviour SGP40.Transport

  @impl SGP40.Transport
  def start_link(_opts) do
    {:ok, :c.pid(0, 0, 0)}
  end

  @impl SGP40.Transport
  def read(_transport, _bytes_to_read) do
    {:ok, "stub"}
  end

  @impl SGP40.Transport
  def write(_transport, _register_and_data) do
    :ok
  end

  @impl SGP40.Transport
  def write(_transport, _register, _data) do
    :ok
  end

  @impl SGP40.Transport
  def write_read(_transport, _register, _bytes_to_read) do
    {:ok, "stub"}
  end
end
