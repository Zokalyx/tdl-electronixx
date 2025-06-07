defmodule TdlWeb.FileChannel do
  use Phoenix.Channel

  def join("file:" <> id, _params, socket) do
    {:ok, assign(socket, :id, id)}
  end

  # We can't push during join. We must do this (recommended by Phoenix error messages themselves)
  def handle_in(:after_join, socket) do
    case Tdl.Repo.get(Tdl.File, socket.assigns.id) do
      nil ->
        push(socket, "file_not_found", %{})
        {:error, %{reason: "File with ID #{socket.assigns.id} not found"}}

      file ->
        push(socket, "initial_load", %{filename: file.filename, content: file.content})
        IO.inspect(file.filename)
        {:ok}
    end
  end

  def handle_in("update", %{"content" => content}, socket) do
    db_file = Tdl.Repo.get(Tdl.File, socket.assigns.id)
    changeset = Tdl.File.changeset(db_file, %{content: content})
    Tdl.Repo.update!(changeset)
    broadcast!(socket, "update", %{content: content})
    {:noreply, socket}
  end
end
