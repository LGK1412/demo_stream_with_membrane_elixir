defmodule Demo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @port 9006
  @local_ip {127, 0, 0, 1}

  @impl true
  def start(_type, _args) do
    rtmp_server_options = %{
      port: @port,
      listen_options: [
        :binary,
        packet: :raw,
        active: false,
        ip: @local_ip
      ],
      # Xử lý các tác vụ khi bấm OBS stream (ví dụ như stream key)
      handle_new_client: fn client_ref, streamer_id, stream_key ->
        # Lấy stream_key từ database để check với cái từ OBS
        stream_key_current =
          case Demo.Repo.get_by(Demo.StreamSetting, streamer_id: streamer_id) do
            nil -> nil
            stream_setting -> stream_setting.stream_key
          end

        Logger.info("stream_key_current: #{stream_key_current}")

        if stream_key == stream_key_current and stream_key_current != nil and streamer_id != nil   do
          # Tạo một stream_infor mới
          IO.inspect(streamer_id, label: "📌 streamer_id trước khi tạo stream")

          result =
            Demo.Streams.create_stream_infor(%{
              streamer_id: streamer_id,
              stream_status: true
            })

          IO.inspect(result, label: "📌 Kết quả create_stream_infor")

          # Lấy stream_id để tạo output_path
          stream_infor = Demo.Streams.get_stream_by_streamer_id(streamer_id)

          case stream_infor do
            nil -> terminate_client_ref(client_ref)
            stream -> IO.inspect(stream, label: "📌 Kết quả stream_infor")
          end

          stream_id = stream_infor.id

          Logger.error("Error to get stream_id $#{stream_id}")

          output_path = "#{stream_id}/index.m3u8"

          case Demo.Streams.update_output_path(stream_infor, output_path) do
            {:ok, updated_stream} -> IO.inspect(updated_stream, label: "✅ Đã cập nhật output_path")
            {:error, changeset} -> IO.inspect(changeset.errors, label: "❌ Lỗi khi cập nhật output_path")
          end

          Logger.info("Starting pipeline for stream key: #{stream_key} + #{stream_key_current}")

          # Gọi modal xác nhận và nhận kết quả
          result = confirm_action()
          Logger.info("User selected: #{result}")
          if !result do
            terminate_client_ref(client_ref)
          end
          # Xóa file output.mp4

          File.rm_rf("output.mp4")

          File.mkdir_p("output/#{stream_id}")

          Logger.info("Client ref: #{inspect(client_ref)}")

          # không đụng dây là chỗ tạo kết một stream mới cho client streamer
          {:ok, _sup, pid} =
            Membrane.Pipeline.start_link(Demo.Pipeline, %{
              client_ref: client_ref,
              app: streamer_id,
              stream_key: stream_key
            })

          {Demo.ClientHandler, %{pipeline: pid, streamer_id: streamer_id}}


        else
          Logger.error("Invalid stream key: #{stream_key}")

          terminate_client_ref(client_ref)
        end
      end
    }

    children = [
      # Start the RTMP server
      %{
        id: Membrane.RTMPServer,
        start: {Membrane.RTMPServer, :start_link, [rtmp_server_options]}
      },
      # Start the Telemetry supervisor
      DemoWeb.Telemetry,
      Demo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Demo.PubSub},
      # Start the Endpoint (http/https)
      DemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RtmpToAdaptiveHls.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp confirm_action do
    topic = "confirm_modal"
    parent = self()

    # Gửi sự kiện yêu cầu xác nhận đến LiveView
    Phoenix.PubSub.broadcast(Demo.PubSub, topic, {:show_modal, parent})

    receive do
      {:modal_result, response} -> response
    end
  end

  def terminate_client_ref(client_ref) do
    Membrane.Pipeline.terminate(client_ref,
      timeout: 5000,
      force?: false,
      asynchronous?: true
    )

    {Demo.ClientHandler, %{pipeline: client_ref}}
  end
end
