defmodule Tdl.File do
  use GenServer

  ## Missing Client API - will add this later

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
  def handle_call({:update, new_text}, _from, _old_text) do
    IO.inspect("Update received: new_text = " <> new_text)
    {:reply, :ok, new_text}
  end
end
