defmodule EshopWeb.IndexLive do
  @moduledoc """
  This is the index page live view.
  """

  use EshopWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Welcome to Eshop!</h1>
      <p>This is the index page.</p>
    </div>
    """
  end

  def mount(params, session, socket) do
    dbg(params)
    dbg(session)
    {:ok, socket}
  end
end
