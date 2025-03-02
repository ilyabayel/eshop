defmodule Eshop.CartAndCheckout do
  @moduledoc false

  alias Eshop.CartAndCheckout.CRUD
  alias Eshop.CartAndCheckout.Services.AddProductToCart
  alias Eshop.CartAndCheckout.Services.FetchCartWithPrices
  alias Eshop.CartAndCheckout.Services.RemoveProductFromCart

  defdelegate delete_cart_item(cart_item), to: CRUD
  defdelegate create_cart_item(attrs), to: CRUD
  defdelegate update_cart_item(cart_item, attrs), to: CRUD
  defdelegate fetch_cart(id), to: CRUD
  defdelegate fetch_cart_item_by(cart_id, product_id), to: CRUD
  defdelegate create_cart(attrs), to: CRUD
  defdelegate fetch_cart_by_session_key(session_key), to: CRUD
  defdelegate add_product_to_cart(cart_id, product_id, diff \\ 1), to: AddProductToCart, as: :call
  defdelegate remove_product_from_cart(cart_id, product_id, diff \\ 1), to: RemoveProductFromCart, as: :call
  defdelegate get_cart_with_prices(cart), to: FetchCartWithPrices, as: :call
end
