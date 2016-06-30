defmodule Broker.Cast do
  @behaviour Leekbot.Broker

  @trakt Application.get_env(:leekbot, :trakt_api_root)
  @headers [
    "Content-Type": "application/json",
    "trakt-api-key": Application.get_env(:leekbot, :trakt_api_key),
    "trakt-api-version": Application.get_env(:leekbot, :trakt_api_version)
  ]

  def handle(title) do
    cast = URI.encode(title)
      |> search
      |> parse_search
      |> get_id
      |> fetch_cast
      |> parse_cast
      |> prettify
    {:ok, cast}
  end

  defp search(title) do
    HTTPoison.get! "#{@trakt}search?page=1&limit=1&query=#{title}&type=movie,show", @headers
  end

  defp parse_search(%HTTPoison.Response{body: body}) do
    Poison.Parser.parse! body
  end

  defp get_id([%{"type" => type, "movie" => movie} | _tail]) do
     get_id(type, movie)
  end

  defp get_id([%{"type" => type, "show" => show} | _tail]) do
     get_id(type, show)
  end

  defp get_id(type, media) do
    {String.to_atom(type), media["ids"]["trakt"]}
  end

  defp fetch_cast({:movie, id}) do
    HTTPoison.get! "#{@trakt}movies/#{id}/people", @headers
  end

  defp fetch_cast({:show, id}) do
    HTTPoison.get! "#{@trakt}shows/#{id}/people", @headers
  end

  defp parse_cast(%HTTPoison.Response{body: body}) do
    Poison.Parser.parse! body
  end

  defp prettify(%{"cast" => cast}) do
    cast
      |> Enum.map(fn %{"character" => character, "person" => %{"name" => name}} -> "#{name}: #{character}" end)
      |> Enum.join("\n")
  end
end
