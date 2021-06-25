defmodule SGP40.VocIndex.AlgorithmStates do
  @moduledoc false

  defstruct [:mean, :std]

  @type t :: %{
          required(:mean) => number,
          required(:std) => number,
          optional(:__struct__) => atom
        }
end
