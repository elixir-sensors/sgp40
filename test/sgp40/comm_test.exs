defmodule SGP40.CommTest do
  use ExUnit.Case, async: true

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    %{transport: :c.pid(0, 0, 0)}
  end

  test "serial_id", %{transport: transport} do
    Mox.expect(SGP40.MockI2C, :write_read, 1, fn _transport, <<0x36, 0x82>>, 3 ->
      {:ok, <<28, 38, 154>>}
    end)

    assert {:ok, "1C269A"} = SGP40.Comm.serial_id(transport)
  end

  test "measure_raw_with_rht", %{transport: transport} do
    SGP40.MockI2C
    |> Mox.expect(
      :write,
      1,
      fn _transport,
         [<<0x26, 0x0F>>, <<_h_val::unsigned-16, _h_crc, _t_val::unsigned-16, _t_crc>>] ->
        :ok
      end
    )
    |> Mox.expect(:read, 1, fn _transport, 2 -> {:ok, 28} end)

    assert {:ok, 28} = SGP40.Comm.measure_raw_with_rht(transport, 50, 25)
  end
end
