defmodule TdlWeb.FileChannel do
  use Phoenix.Channel

  def join("file:" <> _id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("update", %{"content" => content}, socket) do
    broadcast!(socket, "update", %{content: content})
    {:noreply, socket}
  end
end
