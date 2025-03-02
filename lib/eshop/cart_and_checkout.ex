defmodule Eshop.CartAndCheckout do
  @moduledoc false

  alias Eshop.CartAndCheckout.Services.AddProductToCart
  alias Eshop.CartAndCheckout.Services.GetCartWithPrices

  defdelegate add_product_to_cart(cart_id, product_id, quantity), to: AddProductToCart, as: :call
  defdelegate get_cart_with_prices(cart), to: GetCartWithPrices, as: :call
end
