defmodule Eshop.CartAndCheckout.CRUD do
  @moduledoc false

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.Repo

  @spec fetch_cart(integer()) :: {:ok, Cart.t()} | {:error, :not_found}
  def fetch_cart(cart_id) do
    case Repo.fetch(Cart, cart_id) do
      {:ok, cart} -> {:ok, cart}
      {:error, :not_found} -> {:error, "Cart not found"}
    end
  end

  def fetch_cart_item_by(cart_id, product_id) do
    Repo.fetch_by(CartItem, cart_id: cart_id, product_id: product_id)
  end

  def fetch_by_session_key(session_key) do
    Repo.fetch_by(Cart, session_key: session_key)
  end

  def update_cart_item(cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_cart_item(cart_item) do
    Repo.delete(cart_item)
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
