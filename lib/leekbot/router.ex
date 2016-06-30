defmodule Leekbot.Router do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def handle_cast({:route, message, chat_id}, state) do
    route(message, chat_id)
    {:noreply, state}
  end

  def route(router, message, chat_id) do
    GenServer.cast(router, {:route, message, chat_id})
  end

  defp route(message, chat_id) do
    case message do
      "/kana " <> m      -> Broker.Kana.handle(m)
      "/cast " <> m      -> Broker.Cast.handle(m)
      #"/translate " <> m -> {:ok, "Translation"}
      #"/speak " <> m     -> {:ok, "Audio"}
      _ -> {:error, "Unknown command."}
    end |> reply(chat_id)
  end

  defp reply({_, reply}, chat_id), do: Nadia.send_message(chat_id, reply)
end
