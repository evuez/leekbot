defmodule Leekbot.Broker do
  @callback handle(String.t) :: {atom, String.t}
end
