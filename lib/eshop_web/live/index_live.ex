defmodule EshopWeb.IndexLive do
  @moduledoc """
  This is the index page live view.
  """

  use EshopWeb, :live_view

  import EshopWeb.Components.Cart
  import EshopWeb.Components.Navbar
  import EshopWeb.Components.ProductCard

  alias Eshop.CartAndCheckout
  alias Eshop.CartAndCheckout.CRUD

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background">
      <.navbar />
      <main class="container mx-auto px-4 py-8">
        <div class="lg:grid lg:grid-cols-12 lg:gap-x-8">
          <div class="lg:col-span-7 xl:col-span-8 mb-6">
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

  def mount(_params, %{"session_key" => session_key}, socket) do
    products = Eshop.Products.list_products()
    cart = get_or_create_cart(session_key)

    {:ok, cart_with_prices} = CartAndCheckout.get_cart_with_prices(cart)

    {:ok,
     assign(socket,
       products: products,
       cart: cart_with_prices
     )}
  end

  def handle_event("add_item", %{"id" => product_id}, socket) do
    {:ok, cart_with_prices} = CartAndCheckout.add_product_to_cart(socket.assigns.cart.id, product_id)
    {:noreply, assign(socket, cart: cart_with_prices)}
  end

  def handle_event("remove_item", %{"id" => product_id}, socket) do
    {:ok, cart_with_prices} = CartAndCheckout.remove_product_from_cart(socket.assigns.cart.id, product_id)
    {:noreply, assign(socket, cart: cart_with_prices)}
  end

  defp get_or_create_cart(session_key) do
    {:ok, cart} =
      case Eshop.CartAndCheckout.CRUD.fetch_by_session_key(session_key) do
        {:error, _} -> CRUD.create_cart(%{session_key: session_key})
        {:ok, _} = result -> result
      end

    cart
  end
end
