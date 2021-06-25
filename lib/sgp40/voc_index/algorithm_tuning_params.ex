defmodule SGP40.VocIndex.AlgorithmTuningParams do
  @moduledoc false

  @type t :: %{
          required(:voc_index_offset) => 0..0x7FFF_FFFF,
          required(:learning_time_hours) => 0..0x7FFF_FFFF,
          required(:gating_max_duration_minutes) => 0..0x7FFF_FFFF,
          required(:std_initial) => 0..0x7FFF_FFFF,
          optional(:__struct__) => atom
        }
end
