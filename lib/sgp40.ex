defmodule SGP40 do
  @moduledoc """
  Use Sensirion SGP40 air quality sensor in Elixir
  """

  use GenServer, restart: :transient

  require Logger

  @typedoc """
  SGP40 GenServer start_link options
  * `:name` - A name for the `GenServer`
  * `:bus_name` - Which I2C bus to use (defaults to `"i2c-1"`)
  * `:bus_address` - The address of the SGP40 (defaults to `0x59`)
  * `:humidity_rh` - Relative humidity in percent for compensation
  * `:temperature_c` - Temperature in degree Celsius for compensation
  """
  @type options() ::
          [
            {:name, GenServer.name()}
            | {:bus_name, bus_name}
            | {:bus_address, bus_address}
            | {:humidity_rh, number}
            | {:temperature_c, number}
          ]

  @type bus_name :: binary
  @type bus_address :: 0..127

  defmodule State do
    @moduledoc false
    defstruct [
      :humidity_rh,
      :last_measurement,
      :serial_id,
      :temperature_c,
      :transport,
      :voc_index
    ]
  end

  @default_bus_name "i2c-1"
  @default_bus_address 0x59
  @polling_interval_ms 1000
  @default_humidity_rh 50
  @default_temperature_c 25

  @transport_mod Application.compile_env(:sgp40, :transport_mod, SGP40.Transport.I2C)

  @doc """
  Start a new GenServer for interacting with the SGP40 sensor.
  Normally, you'll want to pass the `:bus_name` option to specify the I2C
  bus going to the SGP40.
  """
  @spec start_link(options()) :: GenServer.on_start()
  def start_link(init_arg \\ []) do
    GenServer.start_link(__MODULE__, init_arg, name: init_arg[:name])
  end

  @doc """
  Measure the current air quality.
  """
  @spec measure(GenServer.server()) :: {:ok, SGP40.Measurement.t()} | {:error, any}
  def measure(server) do
    GenServer.call(server, :measure)
  end

  @spec get_states(GenServer.server()) ::
          {:ok, SGP40.VocIndex.AlgorithmStates.t()} | {:error, any}
  def get_states(server) do
    GenServer.call(server, :get_states)
  end

  @spec set_states(GenServer.server(), SGP40.VocIndex.AlgorithmStates.t()) ::
          {:ok, binary} | {:error, any}
  def set_states(server, args) do
    GenServer.call(server, {:set_states, args})
  end

  @spec set_tuning_params(GenServer.server(), SGP40.VocIndex.AlgorithmTuningParams.t()) ::
          {:ok, binary} | {:error, any}
  def set_tuning_params(server, args) do
    GenServer.call(server, {:set_tuning_params, args})
  end

  @doc """
  Update relative ambient humidity (RH %) and ambient temperature (degree C)
  for the humidity compensation.
  """
  @spec update_rht(GenServer.server(), number, number) :: :ok
  def update_rht(server, humidity_rh, temperature_c)
      when is_number(humidity_rh) and is_number(temperature_c) do
    GenServer.cast(server, {:update_rht, humidity_rh, temperature_c})
  end

  @impl GenServer
  def init(init_arg) do
    bus_name = init_arg[:bus_name] || @default_bus_name
    bus_address = init_arg[:bus_address] || @default_bus_address
    humidity_rh = init_arg[:humidity_rh] || @default_humidity_rh
    temperature_c = init_arg[:temperature_c] || @default_temperature_c

    Logger.info(
      "[SGP40] Starting on bus #{bus_name} at address #{inspect(bus_address, base: :hex)}"
    )

    case @transport_mod.open(bus_name: bus_name, bus_address: bus_address) do
      {:ok, transport} ->
        {:ok, serial_id} = SGP40.Comm.serial_id(transport)
        {:ok, voc_index} = SGP40.VocIndex.start_link()

        state = %State{
          humidity_rh: humidity_rh,
          last_measurement: nil,
          serial_id: serial_id,
          temperature_c: temperature_c,
          transport: transport,
          voc_index: voc_index
        }

        {:ok, state, {:continue, :init_sensor}}

      _error ->
        {:stop, :device_not_found}
    end
  end

  @impl GenServer
  def handle_continue(:init_sensor, state) do
    Logger.info("[SGP40] Initializing sensor #{state.serial_id}")

    state = read_and_maybe_put_measurement(state)
    Process.send_after(self(), :schedule_measurement, @polling_interval_ms)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:schedule_measurement, state) do
    state = read_and_maybe_put_measurement(state)
    Process.send_after(self(), :schedule_measurement, @polling_interval_ms)

    {:noreply, state}
  end

  defp read_and_maybe_put_measurement(state) do
    with {:ok, sraw} <-
           SGP40.Comm.measure_raw_with_rht(
             state.transport,
             state.humidity_rh,
             state.temperature_c
           ),
         {:ok, voc_index} <- SGP40.VocIndex.process(state.voc_index, sraw) do
      timestamp_ms = System.monotonic_time(:millisecond)
      measurement = %SGP40.Measurement{timestamp_ms: timestamp_ms, voc_index: voc_index}

      %{state | last_measurement: measurement}
    else
      {:error, reason} ->
        Logger.error("[SGP40] Measurement failed: #{inspect(reason)}")
        state
    end
  end

  @impl GenServer
  def handle_call(:measure, _from, state) do
    {:reply, {:ok, state.last_measurement}, state}
  end

  def handle_call(:get_states, _from, state) do
    {:reply, SGP40.VocIndex.get_states(state.voc_index), state}
  end

  def handle_call({:set_states, args}, _from, state) do
    {:reply, SGP40.VocIndex.set_states(state.voc_index, args), state}
  end

  def handle_call({:set_tuning_params, args}, _from, state) do
    {:reply, SGP40.VocIndex.set_tuning_params(state.voc_index, args), state}
  end

  @impl GenServer
  def handle_cast({:update_rht, humidity_rh, temperature_c}, state) do
    state = %{state | humidity_rh: humidity_rh, temperature_c: temperature_c}

    {:noreply, state}
  end
end
