defmodule TdlWeb.FilesHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use TdlWeb, :html

  embed_templates "files_html/*"
end
