defmodule DemoWeb.VideoController do
  use DemoWeb, :controller

  def convert_and_download(conn, _params) do
    input_path = "./output/index.m3u8"
    output_path = "./output.mp4"
    ffmpeg_cmd = "ffmpeg -i #{input_path} -c:v libx264 -c:a aac #{output_path}"

    # Chạy FFmpeg bất đồng bộ để không chặn request
    Task.start(fn ->
      System.cmd("sh", ["-c", ffmpeg_cmd], stderr_to_stdout: true)
    end)

    # Trả về JSON báo hiệu quá trình đang chạy
    json(conn, %{message: "Đang chuyển đổi, vui lòng đợi..."})
  end

  def check_status(conn, _params) do
    output_path = "./output.mp4"

    if File.exists?(output_path) do
      json(conn, %{status: "done", download_url: "/download/output.mp4"})
    else
      json(conn, %{status: "processing"})
    end
  end

  def downloads(conn, %{"filename" => filename}) do
    path = "./#{filename}"

    if File.exists?(path) do
      conn |> Plug.Conn.send_file(200, path)
    else
      conn |> send_resp(404, "File not found")
    end
  end
end
