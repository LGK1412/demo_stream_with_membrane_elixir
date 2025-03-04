defmodule DemoWeb.PageController do
  use DemoWeb, :controller

  alias Demo.Streams

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :index)
  end

  def stream(conn, %{"streamer_name" => stream_name}) do
    case Streams.get_streamer_id_by_name(stream_name) do
      nil ->
        conn
          |> put_status(:not_found)
          |> put_view(DemoWeb.ErrorHTML)
          |> render("not_user.html")

      streamer_id ->
        if Streams.is_streamer(streamer_id) do
          case Streams.get_stream_by_streamer_id(streamer_id) do
            nil -> render(conn, :stream, stream_infor: nil)
            stream_infor -> render(conn, :stream, stream_infor: stream_infor)
          end
        else
          conn
          |> put_status(:not_found)
          |> put_view(DemoWeb.ErrorHTML)
          |> render("error.html", streamer_name: stream_name)
        end
    end
  end

end
