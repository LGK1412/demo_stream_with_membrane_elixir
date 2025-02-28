defmodule DemoWeb.StreamSettingLive do
  use DemoWeb, :live_view
  alias Demo.{Repo, StreamSetting}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, streamer_id: nil, stream_key: nil)}
  end

  def handle_event("generate_stream_key", %{"streamer_id" => streamer_id}, socket) do
    stream_key = generate_stream_key()

    stream_setting =
      case get_stream_key_by_streamer_id(streamer_id) do
        nil -> create_stream_setting(streamer_id, stream_key)
        stream_setting -> update_stream_key(stream_setting, stream_key)
      end

    {:noreply, assign(socket, streamer_id: streamer_id, stream_key: stream_setting.stream_key)}
  end

  def handle_event("view_stream_key", %{"streamer_id" => streamer_id}, socket) do
    stream_setting = get_stream_key_by_streamer_id(streamer_id)
    stream_key = if stream_setting, do: stream_setting.stream_key, else: "Not Found"

    {:noreply, assign(socket, streamer_id: streamer_id, stream_key: stream_key)}
  end

  def handle_event("copy_stream_key", _, socket) do
    {:noreply, push_event(socket, "copy_stream_key", %{stream_key: socket.assigns.stream_key})}
  end

  defp generate_stream_key do
    :crypto.strong_rand_bytes(12) |> Base.encode16() |> binary_part(0, 16)
  end

  defp get_stream_key_by_streamer_id(streamer_id) do
    Repo.get_by(StreamSetting, streamer_id: streamer_id)
  end

  defp create_stream_setting(streamer_id, stream_key) do
    changeset =
      StreamSetting.changeset(%StreamSetting{}, %{
        streamer_id: streamer_id,
        stream_key: stream_key
      })

    case Repo.insert(changeset) do
      {:ok, stream_setting} -> stream_setting
      {:error, _} -> nil
    end
  end

  defp update_stream_key(stream_setting, stream_key) do
    changeset = StreamSetting.changeset(stream_setting, %{stream_key: stream_key})

    case Repo.update(changeset) do
      {:ok, updated_stream_setting} -> updated_stream_setting
      {:error, _} -> nil
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-lg mx-auto bg-white shadow-lg rounded-lg p-6">
      <h2 class="text-2xl font-bold text-gray-800 mb-4 text-center">Stream Key Management</h2>

      <form phx-submit="generate_stream_key" class="mb-4">
        <label for="streamer_id" class="block text-gray-700 font-semibold">Streamer ID:</label>
        <input
          type="text"
          name="streamer_id"
          id="streamer_id"
          required
          value={@streamer_id || ""}
          class="w-full p-2 border border-gray-300 rounded mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        <button
          type="submit"
          class="w-full mt-3 bg-blue-500 text-white py-2 rounded hover:bg-blue-600 transition"
        >
          Generate Stream Key
        </button>
      </form>

      <form phx-submit="view_stream_key" class="mb-4">
        <label for="streamer_id_view" class="block text-gray-700 font-semibold">Streamer ID:</label>
        <input
          type="text"
          name="streamer_id"
          id="streamer_id_view"
          required
          class="w-full p-2 border border-gray-300 rounded mt-1 focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        <button
          type="submit"
          class="w-full mt-3 bg-green-500 text-white py-2 rounded hover:bg-green-600 transition"
        >
          View Stream Key
        </button>
      </form>

      <%= if @stream_key do %>
        <div class="p-4 bg-gray-100 rounded-lg text-center">
          <p class="text-gray-800 font-semibold">Your Stream Key:</p>
          <p id="stream-key" class="text-lg font-mono bg-gray-200 p-2 rounded mt-2">{@stream_key}</p>
          <button
            phx-click="copy_stream_key"
            class="mt-3 bg-yellow-500 text-white py-2 px-4 rounded hover:bg-yellow-600 transition"
          >
            Copy
          </button>
        </div>
      <% end %>
    </div>

    <script>
      window.addEventListener("phx:copy_stream_key", (e) => {
      navigator.clipboard.writeText(e.detail.stream_key).then(() => {
        alert("Stream Key copied!");
      });
      });
    </script>
    """
  end
end
