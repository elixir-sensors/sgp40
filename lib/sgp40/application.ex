defmodule SGP40.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SGP40.VocIndex
    ]

    opts = [
      name: SGP40.Supervisor,
      strategy: :one_for_one,
      max_restarts: 3,
      max_seconds: 5
    ]

    Supervisor.start_link(children, opts)
  end
end
