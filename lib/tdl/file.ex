defmodule Tdl.File do
  use GenServer

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
