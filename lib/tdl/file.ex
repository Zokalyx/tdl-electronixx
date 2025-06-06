defmodule Tdl.File do
  use Ecto.Schema
  import Ecto.Changeset
  use GenServer

  schema "files" do
    field :filename, :string
    field :content, :string

    belongs_to :folder, YourApp.Folder, foreign_key: :parent_folder_id
    belongs_to :user, YourApp.User
    belongs_to :permission, YourApp.Permission

    timestamps()
  end


  ## Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def update(file, new_text) do
    GenServer.call(file, {:update, new_text})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, ""}
  end

  @impl true
  def handle_call({:update, new_text}, from, old_text) do
    IO.inspect("Before updating: old_text = " <> old_text)
    IO.inspect("Update received from #{inspect(from)}: new_text = " <> new_text)
    {:reply, :ok, new_text}
  end
end
