defmodule Eshop.CartAndCheckout.Services.RemoveProductFromCart do
  @moduledoc false
  alias Eshop.CartAndCheckout
  alias Eshop.CartAndCheckout.Services.FetchCartWithPrices
  alias Eshop.CartAndCheckout.Structs.CartWithPrices
  alias Eshop.Products

  @spec call(integer(), integer(), pos_integer()) :: {:ok, CartWithPrices.t()} | {:error, Ecto.Changeset.t() | :not_found}
  def call(cart_id, product_id, diff) when diff > 0 do
    with {:ok, cart} <- CartAndCheckout.fetch_cart(cart_id),
         {:ok, _} <- Products.fetch_product(product_id),
         {:ok, _} <- update_or_delete_cart_item(cart_id, product_id, diff) do
      FetchCartWithPrices.call(cart)
    end
  end

  defp update_or_delete_cart_item(cart_id, product_id, diff) do
    {:ok, cart_item} = CartAndCheckout.fetch_cart_item_by(cart_id, product_id)

    new_quantity = cart_item.quantity - diff

    if new_quantity > 0 do
      CartAndCheckout.update_cart_item(cart_item, %{quantity: new_quantity})
    else
      CartAndCheckout.delete_cart_item(cart_item)
    end
  end
end
