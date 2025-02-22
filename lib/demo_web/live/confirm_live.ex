defmodule DemoWeb.ConfirmLive do
  use DemoWeb, :live_view

  @topic "confirm_modal"

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Demo.PubSub, @topic)
    {:ok, assign(socket, show_modal: false, parent_pid: nil)}
  end

  def handle_info({:show_modal, parent_pid}, socket) do
    {:noreply, assign(socket, show_modal: true, parent_pid: parent_pid)}
  end

  def handle_event("confirm", _, socket) do
    send(socket.assigns.parent_pid, {:modal_result, true})
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_event("cancel", _, socket) do
    send(socket.assigns.parent_pid, {:modal_result, false})
    {:noreply, assign(socket, show_modal: false)}
  end

  def render(assigns) do
    ~H"""
    <%= if @show_modal do %>
      <div class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
        <div class="bg-white p-4 rounded shadow">
          <p>Còn video cũ bạn hãy đảm bão đã tải xuống. Bạn có muốn tiếp tục?</p>
          <button phx-click="confirm" class="bg-green-500 text-white px-4 py-2 rounded">Có</button>
          <button phx-click="cancel" class="bg-red-500 text-white px-4 py-2 rounded ml-2">Không</button>
        </div>
      </div>
    <% end %>
    """
  end
end
