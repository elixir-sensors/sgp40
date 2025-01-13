defmodule SGP40.VocIndexTestTest do
  use ExUnit.Case, async: true
  alias SGP40.VocIndex

  test "process" do
    pid = start_supervised!(SGP40.VocIndex)

    {:ok, voc_index} = VocIndex.process(pid, 123)

    assert is_integer(voc_index)
  end

  test "get_states" do
    pid = start_supervised!(SGP40.VocIndex)

    {:ok, states} = VocIndex.get_states(pid)

    assert %{mean: mean, std: std} = states
    assert is_integer(mean)
    assert is_integer(std)
  end

  test "set_states" do
    pid = start_supervised!(SGP40.VocIndex)

    assert {:ok, echo} = VocIndex.set_states(pid, %{mean: 1, std: 2})

    assert echo =~ ~r/mean:\d*,std:\d*/
  end

  test "set_tuning_params" do
    pid = start_supervised!(SGP40.VocIndex)

    params = %{
      voc_index_offset: 1,
      learning_time_hours: 2,
      gating_max_duration_minutes: 3,
      std_initial: 4
    }

    assert {:ok, echo} = VocIndex.set_tuning_params(pid, params)

    assert echo ==
             "voc_index_offset:1,learning_time_hours:2,gating_max_duration_minutes:3,std_initial:4"
  end
end
