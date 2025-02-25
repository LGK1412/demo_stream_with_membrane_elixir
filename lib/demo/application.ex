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
    File.mkdir_p("output")

    rtmp_server_options = %{
      port: @port,
      listen_options: [
        :binary,
        packet: :raw,
        active: false,
        ip: @local_ip
      ],
      # Xử lý các tác vụ khi bấm OBS stream (ví dụ như stream key)
      handle_new_client: fn client_ref, app, stream_key ->
        if stream_key == "hehe" do
          Logger.info("Starting pipeline for stream key: #{stream_key}")

          # Gọi modal xác nhận và nhận kết quả
          result = confirm_action()
          IO.puts("User selected: #{result}")
          Logger.info("User selected: #{result}")
          Logger.debug("User selected: #{result}")
          # Xóa file output.mp4

          File.rm_rf("output.mp4")

          File.rm_rf("output")

          File.mkdir_p("output")



          Logger.info("Client ref: #{inspect(client_ref)}")

          # không đụng dây là chỗ tạo kết một stream mới cho client streamer
          {:ok, _sup, pid} =
            Membrane.Pipeline.start_link(Demo.Pipeline, %{
              client_ref: client_ref,
              app: app,
              stream_key: stream_key
            })

          {Demo.ClientHandler, %{pipeline: pid}}
        else
          Logger.error("Invalid stream key: #{stream_key}")

          Logger.info("Client ref: #{inspect(client_ref)}")

          # ❌ pipeline_pid ở đây không có giá trị, phải lấy từ đâu đó
          Membrane.Pipeline.terminate(client_ref,
            timeout: 5000,
            force?: false,
            asynchronous?: true
          )

          {Demo.ClientHandler, %{pipeline: client_ref}}
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

end
