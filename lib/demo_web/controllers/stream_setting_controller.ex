defmodule DemoWeb.StreamSettingController do
  use DemoWeb, :controller

  alias Demo.StreamSetting

  def create_stream_key(conn, %{"streamer_id" => streamer_id}) do
    stream_key = generate_stream_key()

    stream_setting =
      case get_key_setting_by_streamer_id(streamer_id) do
        nil -> create_stream_setting(streamer_id, stream_key)
        stream_setting -> update_stream_key(stream_setting, stream_key)
      end

    render(conn, "create_stream_key.html",
      stream_key: stream_setting && stream_setting.stream_key,
      streamer_id: streamer_id
    )
  end

  defp generate_stream_key do
    :crypto.strong_rand_bytes(12) |> Base.encode16() |> binary_part(0, 16)
  end

  def get_key_setting_by_streamer_id(streamer_id) do
    Demo.Repo.get_by(StreamSetting, streamer_id: streamer_id)
  end

  defp create_stream_setting(streamer_id, stream_key) do
    changeset =
      StreamSetting.changeset(%StreamSetting{}, %{
        streamer_id: streamer_id,
        stream_key: stream_key
      })

    case Demo.Repo.insert(changeset) do
      {:ok, stream_setting} -> stream_setting
      {:error, _} -> nil
    end
  end

  defp update_stream_key(stream_setting, stream_key) do
    changeset = StreamSetting.changeset(stream_setting, %{stream_key: stream_key})

    case Demo.Repo.update(changeset) do
      {:ok, updated_stream_setting} -> updated_stream_setting
      {:error, _} -> nil
    end
  end
end
