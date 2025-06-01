defmodule TdlWeb.Editor do
  use TdlWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="text-black max-w-4xl mx-auto p-6 bg-white shadow-md rounded-lg">
      <!--input
        type="text"
        name="title"
        class="p-3 mb-4 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:outline-none"
        placeholder="Title"
      /> <span class="text-black">.md</span-->
      <h1>
        {@id} [reemplazar con nombre de archivo en vez de ID]
      </h1>
       <textarea
        id="file-textarea"
        id="text"
        name="text"
        rows="10"
        class="font-mono text-black w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:outline-none resize-none"
        placeholder=""
      ></textarea>
    </section>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, :id, id)}
  end
end
