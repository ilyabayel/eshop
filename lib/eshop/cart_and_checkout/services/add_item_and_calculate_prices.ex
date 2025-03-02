defmodule Eshop.CartAndCheckout.Services.AddItemAndCalculatePrices do
  @moduledoc false
  alias Eshop.CartAndCheckout.CRUD
  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Services.GetCartWithPrices
  alias Eshop.CartAndCheckout.Structs.CartWithPrices
  alias Eshop.Products.Schemas.Product

  @spec call(Cart.t(), Product.t()) :: {:ok, CartWithPrices.t()} | {:error, Ecto.Changeset.t() | :not_found}
  def call(cart, product) do
    with {:ok, _} <- CRUD.create_cart_item(%{cart_id: cart.id, product_id: product.id}),
         {:ok, cart} <- CRUD.fetch_cart(cart.id) do
      GetCartWithPrices.call(cart.id)
    end
  end
end
