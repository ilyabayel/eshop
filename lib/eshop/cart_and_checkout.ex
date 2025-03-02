defmodule Eshop.CartAndCheckout do
  @moduledoc false

  alias Eshop.CartAndCheckout.Services.AddProductToCart
  alias Eshop.CartAndCheckout.Services.FetchCartWithPrices
  alias Eshop.CartAndCheckout.Services.RemoveProductFromCart

  defdelegate add_product_to_cart(cart_id, product_id, diff \\ 1), to: AddProductToCart, as: :call
  defdelegate remove_product_from_cart(cart_id, product_id, diff \\ 1), to: RemoveProductFromCart, as: :call
  defdelegate get_cart_with_prices(cart), to: FetchCartWithPrices, as: :call
end
