defmodule Eshop.CartAndCheckout.CRUD do
  @moduledoc false

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.Repo

  @spec fetch_cart(integer()) :: {:ok, Cart.t()} | {:error, :not_found}
  def fetch_cart(cart_id) do
    Repo.fetch(Cart, cart_id)
  end

  @spec create_cart(map()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def create_cart(attrs) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_cart_item(map()) :: {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def create_cart_item(attrs) do
    %CartItem{}
    |> CartItem.changeset(attrs)
    |> Repo.insert()
  end
end
