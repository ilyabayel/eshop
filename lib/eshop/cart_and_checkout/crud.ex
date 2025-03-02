defmodule Eshop.CartAndCheckout.CRUD do
  @moduledoc false

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.Repo

  @spec create_cart(map()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def create_cart(attrs) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @spec fetch_cart(integer()) :: {:ok, Cart.t()} | {:error, String.t()}
  def fetch_cart(cart_id) do
    case Repo.fetch(Cart, cart_id) do
      {:ok, cart} -> {:ok, cart}
      {:error, :not_found} -> {:error, "Cart not found"}
    end
  end

  @spec fetch_cart_by_session_key(String.t()) :: {:ok, Cart.t()} | {:error, :not_found}
  def fetch_cart_by_session_key(session_key) do
    Repo.fetch_by(Cart, session_key: session_key)
  end

  @spec create_cart_item(map()) :: {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def create_cart_item(attrs) do
    %CartItem{}
    |> CartItem.changeset(attrs)
    |> Repo.insert()
  end

  @spec delete_cart_item(CartItem.t()) :: {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def delete_cart_item(cart_item) do
    Repo.delete(cart_item)
  end

  @spec fetch_cart_item_by(integer(), integer()) :: {:ok, CartItem.t()} | {:error, :not_found}
  def fetch_cart_item_by(cart_id, product_id) do
    Repo.fetch_by(CartItem, cart_id: cart_id, product_id: product_id)
  end

  @spec update_cart_item(CartItem.t(), map()) :: {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def update_cart_item(cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end
end
