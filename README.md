# SGP40

[![Hex version](https://img.shields.io/hexpm/v/sgp40.svg "Hex version")](https://hex.pm/packages/sgp40)
[![CI](https://github.com/mnishiguchi/sgp40/actions/workflows/ci.yml/badge.svg)](https://github.com/mnishiguchi/sgp40/actions/workflows/ci.yml)

Use [Sensirion SGP40](https://www.sensirion.com/en/environmental-sensors/gas-sensors/sgp40/) air quality sensor in Elixir.

The raw signal from the SGP40 sensor is processed using [Sensirion's software algorithm](https://github.com/Sensirion/embedded-sgp/blob/00768191892b2cc0d839ebf95998fc4a85b660c4/sgp40_voc_index/sensirion_voc_algorithm.h#L1) to give the [VOC Index](https://cdn.sparkfun.com/assets/e/9/3/f/e/GAS_AN_SGP40_VOC_Index_for_Experts_D1.pdf) that represents an air quality value on a scale from 0 to 500 where a lower value represents cleaner air.

## Usage

```elixir
iex> {:ok, sgp} = SGP40.start_link(bus_name: "i2c-1")
{:ok, #PID<0.1407.0>}

iex> SGP40.measure(sgp)
{:ok, %SGP40.Measurement{voc_index: 123, timestamp_ms: 885906}}
```

For better accuracy, you can provide the SGP40 sensor with relative ambient humidity and ambient temperature from an external humidity sensor periodically.

```elixir
iex> SGP40.update_rht(sgp, humidity_rh, temperature_c)
:ok
```

Depending on your hardware configuration, you may need to modify the call to
`SGP40.start_link/1`. See `t:SGP40.options/0` for parameters.
