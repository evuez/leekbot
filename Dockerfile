FROM elixir:latest

RUN mkdir /leekbot
ADD . leekbot

WORKDIR /leekbot

RUN yes | mix deps.get
RUN yes | mix deps.compile
