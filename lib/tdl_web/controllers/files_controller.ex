defmodule TdlWeb.FilesController do
  use TdlWeb, :controller
  def index(conn, _params) do

    render(conn, :files)
  end

  def folder(conn, %{"id" => folder_id}) do
    message = "Aca se abre la carpeta #{folder_id}"
    text(conn, message)
  end
end

