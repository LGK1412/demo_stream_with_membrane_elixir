defmodule DemoWeb.VideoController do
  use DemoWeb, :controller

  def convert_and_download(conn, _params) do
    IO.puts("Starting conversion process...")

    IO.puts("Removing old files...")
    File.rm_rf("./output.mp4")

    ffmpeg_cmd = "ffmpeg -i ./output/index.m3u8 -c:v libx264 -c:a aac ./output.mp4"

    # Chạy FFmpeg bất đồng bộ để không chặn request
    Task.start(fn ->
      System.cmd("sh", ["-c", ffmpeg_cmd], stderr_to_stdout: true)
    end)

    # Trả về JSON báo hiệu quá trình đang chạy
    json(conn, %{message: "Đang chuyển đổi, vui lòng đợi..."})
  end

  def check_status(conn, _params) do
    IO.puts("Checking conversion status...")

    output_path = "./output.mp4"

    if ffmpeg_running?() do
      json(conn, %{status: "processing"})
    else
      if File.exists?(output_path) do
        json(conn, %{status: "done", download_url: "/download/output.mp4"})
      else
        json(conn, %{status: "processing"})
      end
    end
  end

  defp ffmpeg_running? do
    # Kiểm tra tiến trình FFmpeg theo hệ điều hành
    case :os.type() do
      {:unix, _} ->
        System.cmd("pgrep", ["-f", "ffmpeg"])
        |> elem(1) == 0 # Nếu `pgrep` tìm thấy tiến trình FFmpeg thì return true

      {:win32, _} ->
        {output, _} = System.cmd("tasklist", [])
        String.contains?(output, "ffmpeg.exe") # Kiểm tra nếu ffmpeg.exe đang chạy
    end
  end


  def downloads(conn, %{"filename" => filename}) do
    IO.puts("Downloading file....")

    path = "./#{filename}"

    if File.exists?(path) do
      html_response = """
      <html>
        <body>
          <script>
            // Tạo một thẻ a ẩn để tự động tải file
            const a = document.createElement('a');
            a.href = '/download_file/#{filename}';
            a.download = '#{filename}';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);

            // Sau khi tải, chuyển hướng
            setTimeout(() => { window.location.href = "/custom_stream"; }, 10000);
          </script>
          <p>Đang tải file... Nếu không tự động tải, <a href="/download_file/#{filename}" download>nhấn vào đây</a>.</p>
        </body>
      </html>
      """

      conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, html_response)
    else
      conn |> send_resp(404, "File not found")
    end
  end

  def download_file(conn, %{"filename" => filename}) do
    path = "./#{filename}"

    if File.exists?(path) do
      conn
      |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}\"")
      |> Plug.Conn.send_file(200, path)
    else
      conn |> send_resp(404, "File not found")
    end
  end

  def check_video(conn, _params) do
    IO.puts("Checking video...")

    # Kiểm tra xem video đã được chuyển đổi chưa
    if File.exists?("./output.mp4") do
      json(conn, %{status: "done", download_url: "/download/output.mp4"})
    else
      json(conn, %{status: "processing"})
    end
  end

end
