defmodule DemoWeb.CustomStreamController do
  use DemoWeb, :controller

  def index(conn, _params) do

    render(conn, :custom_stream)
  end
end
