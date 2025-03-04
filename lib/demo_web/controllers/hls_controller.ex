defmodule DemoWeb.HlsController do
  use DemoWeb, :controller

  alias Plug
  require Logger

  def index(conn, %{"filename" => filename_parts}) do
    filename = Path.join(filename_parts)

    path = Path.join(["output", filename])

    if File.exists?(path) do
      conn |> Plug.Conn.send_file(200, path)
    else
      conn |> Plug.Conn.send_resp(404, "File not found")
    end
  end
end
