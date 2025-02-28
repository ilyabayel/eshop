defmodule Eshop.CartAndCheckout.Schemas.Cart do
  @moduledoc """
  Cart schema for Eshop application.

  Cart could belong to user, but also it could be anonymous
  in case user haven't signed in.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.Accounts.User
  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.Products.Schemas.Product

  @type t :: %Cart{}

  schema "carts" do
    many_to_many :products, Product, join_through: "carts_products"
    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(Cart.t(), map()) :: Ecto.Changeset.t()
  def changeset(%Cart{} = cart, attrs) do
    optional_fields = [:user_id]

    cast(cart, attrs, optional_fields)
  end
end
