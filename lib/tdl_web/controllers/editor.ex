defmodule TdlWeb.Editor do
  use TdlWeb, :live_view
  alias Tdl.Repo
  alias Tdl.File

  def render(assigns) do
    ~H"""
    <script src="https://cdn.jsdelivr.net/npm/markdown-it/dist/markdown-it.min.js">
    </script>
    <section class="text-black max-w-4xl mx-auto p-6 bg-white shadow-md rounded-lg">
      <!--input
        type="text"
        name="title"
        class="p-3 mb-4 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:outline-none"
        placeholder="Title"
      /> <span class="text-black">.md</span-->
      <h1 id="file-title">{@file.filename}</h1>

      <div class="flex gap-4">
        <textarea
          id="file-textarea"
          id="text"
          name="text"
          rows="10"
          class="font-mono text-black w-1/2 p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:outline-none resize-none"
          placeholder=""
        ><%= @file.content %></textarea>

        <div id="markdown-output" class="w-1/2 mt-0 p-3 border border-gray-300 rounded-md bg-gray-50">
        </div>
      </div>
    </section>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    case Repo.get(File, id) do
      nil ->
        {:halt, socket |> put_flash(:error, "File not found") |> push_redirect(to: "/files")}

      file ->
        {:ok, assign(socket, file: file)}
    end
  end
end
