defmodule EshopWeb.Components.Navbar do
  @moduledoc false
  use EshopWeb, :component

  attr :user, :map, required: true

  def navbar(assigns) do
    ~H"""
    <nav class="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div class="container flex h-16 items-center px-4 mx-auto">
        <div class="flex flex-1 items-center lg:items-stretch justify-start">
          <div class="flex flex-shrink-0 items-center">
            <img
              class="h-8 w-auto"
              src="https://i.ytimg.com/vi/-rdzt2l-rDE/maxresdefault.jpg"
              alt="Your Company"
            />
          </div>
        </div>

        <div class="flex items-center justify-end gap-4">
          <.link navigate={~p"/users/settings"} class="">
            <img
              src="/images/user-avatar.png"
              alt="user avatar"
              class="rounded-full object-cover h-8 w-8"
            />
          </.link>
        </div>
      </div>
    </nav>
    """
  end
end
