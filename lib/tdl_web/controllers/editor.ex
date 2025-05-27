defmodule TdlWeb.Editor do
  use TdlWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-change="update">
      <textarea type="text" name="text" />
    </form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("update", %{"text" => text}, socket) do
    Tdl.File.update(Tdl.File, text)
    {:noreply, socket}
  end
end
