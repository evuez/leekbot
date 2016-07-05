defmodule Leekbot.Poller do
  def start_link(router) do
    Task.start_link(__MODULE__, :poll, [router, 0])
  end

  def poll(router, offset) do
    {:ok, updates} = Nadia.get_updates offset: offset

    for u <- updates, do: Leekbot.Router.route(router, u.message.text, u.message.chat.id)

    poll(router, offset(updates))
  end

  defp offset([]), do: 0
  defp offset(up), do: List.last(up).update_id + 1
end
