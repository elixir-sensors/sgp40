defmodule SGP40.Measurement do
  @moduledoc """
  One sensor measurement
  """

  defstruct [:timestamp_ms, :voc_index]

  @type t :: %{
          required(:timestamp_ms) => number,
          required(:voc_index) => number,
          optional(:__struct__) => atom
        }
end
