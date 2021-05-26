defmodule SGP40.Measurement do
  @moduledoc false

  defstruct [:timestamp_ms, :voc_index]

  @type t :: %__MODULE__{
          timestamp_ms: number(),
          voc_index: number()
        }
end
