defmodule SGP40.VocIndexTestTest do
  use ExUnit.Case, async: true
  alias SGP40.VocIndex

  test "process" do
    {:ok, voc_index} = VocIndex.process(123)

    assert is_integer(voc_index)
  end

  test "get_states" do
    {:ok, states} = VocIndex.get_states()

    assert %{mean: mean, std: std} = states
    assert is_integer(mean)
    assert is_integer(std)
  end

  test "set_states" do
    assert {:ok, echo} = VocIndex.set_states(%{mean: 1, std: 2})

    assert echo =~ ~r/mean:\d*,std:\d*/
  end

  test "set_tuning_params" do
    params = %{
      voc_index_offset: 1,
      learning_time_hours: 2,
      gating_max_duration_minutes: 3,
      std_initial: 4
    }

    assert {:ok, echo} = VocIndex.set_tuning_params(params)

    assert echo ==
             "voc_index_offset:1,learning_time_hours:2,gating_max_duration_minutes:3,std_initial:4"
  end
end
