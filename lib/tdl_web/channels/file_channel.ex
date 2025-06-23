defmodule TdlWeb.FileChannel do
  use Phoenix.Channel
  alias Tdl.Repo
  alias Tdl.File

  # 5 seconds
  @save_interval 5_000

  def join("file:" <> id, _params, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, %{id: id, last_content: ""})}
  end

  def handle_info(:after_join, socket) do
    case Repo.get(File, socket.assigns.id) do
      nil ->
        push(socket, "file_not_found", %{})
        {:stop, :file_not_found, socket}

      file ->
        push(socket, "initial_load", %{filename: file.filename, content: file.content})
        IO.inspect(file.filename)
        {:noreply, assign(socket, :last_content, file.content)}
    end
  end

  def handle_info(:save_file, socket) do
    file_id = socket.assigns.id
    content_to_save = socket.assigns.last_content

    case Repo.get(File, file_id) do
      nil ->
        IO.warn("Attempted to save file ID #{file_id} but it was not found in DB.")

      db_file ->
        if db_file.content != content_to_save do
          changeset = File.changeset(db_file, %{content: content_to_save})

          case Repo.update(changeset) do
            {:ok, _updated_file} ->
              IO.puts("File ID #{file_id} saved successfully after 5 seconds.")

            {:error, %{errors: errors}} ->
              IO.warn("Failed to save file ID #{file_id}: #{inspect(errors)}")
          end
        else
          IO.puts("File ID #{file_id} content unchanged, skipping save.")
        end
    end

    {:noreply, assign(socket, :save_timer, nil)}
  end

  def handle_in("update", %{"content" => content}, socket) do
    broadcast!(socket, "update", %{content: content})

    socket = assign(socket, :last_content, content)

    if timer = socket.assigns[:save_timer] do
      Process.cancel_timer(timer)
    end

    timer = Process.send_after(self(), :save_file, @save_interval)
    socket = assign(socket, :save_timer, timer)

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    if timer = socket.assigns[:save_timer] do
      Process.cancel_timer(timer)
    end

    :ok
  end
end
