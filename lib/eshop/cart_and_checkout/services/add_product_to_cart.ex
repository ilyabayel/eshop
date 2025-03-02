defmodule Eshop.CartAndCheckout.Services.AddProductToCart do
  @moduledoc false
  alias Eshop.CartAndCheckout
  alias Eshop.CartAndCheckout.Services.FetchCartWithPrices
  alias Eshop.CartAndCheckout.Structs.CartWithPrices
  alias Eshop.Products

  @spec call(integer(), integer(), pos_integer()) :: {:ok, CartWithPrices.t()} | {:error, Ecto.Changeset.t() | :not_found}
  def call(cart_id, product_id, diff \\ 1) when diff > 0 do
    with {:ok, cart} <- CartAndCheckout.fetch_cart(cart_id),
         {:ok, _} <- Products.fetch_product(product_id),
         {:ok, _} <- upsert_cart_item(cart_id, product_id, diff) do
      FetchCartWithPrices.call(cart)
    end
  end

  defp upsert_cart_item(cart_id, product_id, diff) do
    case CartAndCheckout.fetch_cart_item_by(cart_id, product_id) do
      {:ok, cart_item} ->
        CartAndCheckout.update_cart_item(cart_item, %{quantity: cart_item.quantity + diff})

      {:error, :not_found} ->
        CartAndCheckout.create_cart_item(%{cart_id: cart_id, product_id: product_id, quantity: diff})
    end
  end
end
