defmodule EshopWeb.IndexLive do
  @moduledoc """
  This is the index page live view.
  """

  use EshopWeb, :live_view

  import EshopWeb.Components.Cart
  import EshopWeb.Components.Navbar
  import EshopWeb.Components.ProductCard

  alias Eshop.Products

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background">
      <.navbar />
      <main class="container mx-auto px-4 py-8">
        <div class="lg:grid lg:grid-cols-12 lg:gap-x-8">
          <div class="lg:col-span-7 xl:col-span-8">
            <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3">
              <.product_card :for={product <- @products} product={product} />
            </div>
          </div>
          <div class="lg:col-span-5 xl:col-span-4 relative">
            <.cart cart={@cart} />
          </div>
        </div>
      </main>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    products = Eshop.Products.list()

    {:ok,
     assign(socket,
       products: products,
       cart: %{
         items: [],
         total: Money.new(0),
         subtotal: Money.new(0),
         discount: Money.new(0)
       }
     )}
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    {:ok, product} = Products.CRUD.fetch(id)
    {:noreply, put_flash(socket, :info, "#{product.title} added to cart")}
  end
end
