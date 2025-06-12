defmodule TdlWeb.FilesController do
  use TdlWeb, :controller
  alias Tdl.{Repo, File, Folder}

  import Ecto.Query, only: [from: 2]

  def index(conn, %{"folder_id" => folder_id}) do
    current_user = conn.assigns[:current_user]
    folder = Repo.get!(Tdl.Folder, folder_id)

    subfolders_query =
      from(f in Tdl.Folder,
        where: f.parent_folder_id == ^folder.id
      )

    subfolders = Repo.all(subfolders_query)

    files_query =
      from(f in Tdl.File,
        where: f.user_id == ^current_user.id and f.parent_folder_id == ^folder.id
      )

    files = Repo.all(files_query)

    render(conn, :files, folder: folder, subfolders: subfolders, files: files)
  end

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    files_query =
      from(f in Tdl.File,
        where: f.user_id == ^current_user.id and is_nil(f.parent_folder_id),
        select: f
      )

    files = Tdl.Repo.all(files_query)

    folders_query =
      from(f in Tdl.Folder,
        where: is_nil(f.parent_folder_id)
      )

    folders = Tdl.Repo.all(folders_query)

    render(conn, :files, folder: nil, subfolders: folders, files: files)
  end

  def create_file(conn, %{
        "file" => %{"filename" => filename, "parent_folder_id" => parent_folder_id_param}
      }) do
    user_id = conn.assigns.current_user.id

    parsed_parent_folder_id =
      if parent_folder_id_param == "", do: nil, else: String.to_integer(parent_folder_id_param)

    file_params = %{
      "filename" => filename,
      "content" => "",
      "user_id" => user_id,
      "parent_folder_id" => parsed_parent_folder_id
    }

    case Tdl.Files.create_file(file_params) do
      {:ok, file} ->
        redirect(conn, to: ~p"/editor/#{file.id}")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error creating file")
        |> redirect(to: ~p"/files")
    end
  end

  def create_folder(conn, %{"folder" => folder_params}) do
    parent_folder_id_param = Map.get(folder_params, "parent_folder_id")

    parsed_parent_folder_id =
      if parent_folder_id_param == "", do: nil, else: String.to_integer(parent_folder_id_param)

    case Tdl.Files.create_folder(folder_params) do
      {:ok, _folder} ->
        redirect_path =
          if parsed_parent_folder_id do
            ~p"/files/#{parsed_parent_folder_id}"
          else
            ~p"/files"
          end

        redirect(conn, to: redirect_path)

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "No se pudo crear la carpeta.")
        |> redirect(to: ~p"/files")
    end
  end
end
