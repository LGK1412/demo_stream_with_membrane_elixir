defmodule Demo.StreamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Demo.Streams` context.
  """

  @doc """
  Generate a stream_infor.
  """
  def stream_infor_fixture(attrs \\ %{}) do
    {:ok, stream_infor} =
      attrs
      |> Enum.into(%{
        output_path: "some output_path",
        stream_status: true,
        streamer_id: 42,
      })
      |> Demo.Streams.create_stream_infor()

    stream_infor
  end
end
