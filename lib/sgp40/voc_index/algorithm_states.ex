# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule SGP40.VocIndex.AlgorithmStates do
  @moduledoc false

  defstruct [:mean, :std]

  @type t :: %{
          required(:mean) => number,
          required(:std) => number,
          optional(:__struct__) => atom
        }
end
