defmodule Leekbot do
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Leekbot.Router, [Leekbot.Poller]),
      worker(Leekbot.Poller, [Leekbot.Poller])
    ]

    opts = [strategy: :one_for_one, name: Leekbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
