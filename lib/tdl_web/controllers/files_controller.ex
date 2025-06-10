defmodule TdlWeb.FilesController do
  use TdlWeb, :controller
  alias Tdl.{Repo, File}

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    import Ecto.Query, only: [from: 2]

    files_query =
      from(f in Tdl.File,
        join: p in assoc(f, :permissions),
        where: p.user_id == ^current_user.id,
        select: f
      )

    files = Tdl.Repo.all(files_query)

    render(conn, :files, files: files)
  end

  def create(conn, %{"file" => %{"filename" => filename}}) do
    user_id = conn.assigns.current_user.id
    
    case Tdl.Files.create_file(%{"filename" => filename, "content" => "", "user_id" => user_id}) do
      {:ok, file} ->
        redirect(conn, to: ~p"/editor/#{file.id}")
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error creating file")
        |> redirect(to: ~p"/files")
    end
  end

  def folder(conn, %{"id" => folder_id}) do
    message = "Aca se abre la carpeta #{folder_id}"
    text(conn, message)
  end
end
