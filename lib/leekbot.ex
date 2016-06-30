defmodule Leekbot do
  def start_link do
    {:ok, router} = Leekbot.Router.start_link
    Task.start_link(Leekbot.Poller, :poll, [router, 0])
  end
end
