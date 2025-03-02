defmodule Eshop.CartAndCheckout.Services.AddProductToCart do
  @moduledoc """
  Actually I don't like name of this module, and I would like to change it to something more descriptive.
  But I don't have enough time for it, I need work to be done.
  """
  alias Eshop.CartAndCheckout
  alias Eshop.CartAndCheckout.Services.GetCartWithPrices
  alias Eshop.CartAndCheckout.Structs.CartWithPrices
  alias Eshop.Products

  @spec call(integer(), integer(), integer()) :: {:ok, CartWithPrices.t()} | {:error, Ecto.Changeset.t() | :not_found}
  def call(cart_id, product_id, quantity) do
    with {:ok, cart} <- CartAndCheckout.CRUD.fetch_cart(cart_id),
         {:ok, _} <- Products.CRUD.fetch_product(product_id),
         {:ok, _} <- upsert_or_delete_cart_item(cart_id, product_id, quantity) do
      GetCartWithPrices.call(cart)
    end
  end

  defp upsert_or_delete_cart_item(cart_id, product_id, quantity) do
    case CartAndCheckout.CRUD.fetch_cart_item_by(cart_id, product_id) do
      {:ok, cart_item} ->
        new_quantity = cart_item.quantity + quantity

        if new_quantity > 0 do
          CartAndCheckout.CRUD.update_cart_item(cart_item, %{quantity: new_quantity})
        else
          CartAndCheckout.CRUD.delete_cart_item(cart_item)
        end

      {:error, :not_found} ->
        CartAndCheckout.CRUD.create_cart_item(%{cart_id: cart_id, product_id: product_id, quantity: quantity})
    end
  end
end
