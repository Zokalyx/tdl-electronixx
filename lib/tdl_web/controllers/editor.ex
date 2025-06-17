defmodule TdlWeb.Editor do
  use TdlWeb, :live_view
  alias Tdl.Repo
  alias Tdl.File

  def render(assigns) do
    ~H"""
    <section class="text-black max-w-4xl mx-auto p-6 bg-white shadow-md rounded-lg">
      <h1 id="file-title">{@file.filename}</h1>

      <div class="flex gap-4">
        <textarea
          id="file-textarea"
          name="text"
          rows="10"
          class="font-mono text-black w-1/2 p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:outline-none resize-none"
        ><%= @file.content %></textarea>

        <div
          id="markdown-output"
          class="w-1/2 mt-0 p-3 border border-gray-300 rounded-md markdown-body"
        >
        </div>
      </div>
    </section>

    <!-- markdown-it -->
    <script src="https://cdn.jsdelivr.net/npm/markdown-it/dist/markdown-it.min.js">
    </script>

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-light.min.css"
    />
    <style>
      /* Overwrite app.css for bullet points and numbered lists */
      .markdown-body ul {
        list-style-type: disc !important; /* Forces bullet points */
      }
      .markdown-body ol {
        list-style-type: decimal !important; /* Forces numbered lists */
      }
      .markdown-body ul, .markdown-body ol {
        margin-left: 2em !important; /* Adjust indentation as needed */
        padding-left: 0 !important; /* github-markdown-css handles this, but good to be explicit if still issues */
      }
      .markdown-body ul ul { list-style-type: circle !important; }
      .markdown-body ul ul ul { list-style-type: square !important; }
      .markdown-body ol ol { list-style-type: lower-alpha !important; }
      .markdown-body ol ol ol { list-style-type: lower-roman !important; }
    </style>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const textarea = document.getElementById("file-textarea");
        const output = document.getElementById("markdown-output");
        const md = window.markdownit();

        function updatePreview() {
          output.innerHTML = md.render(textarea.value);
        }

        textarea.addEventListener("input", updatePreview);
        updatePreview(); // Initial render
      });
    </script>
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
