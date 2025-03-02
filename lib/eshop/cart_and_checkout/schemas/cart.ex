defmodule Eshop.CartAndCheckout.Schemas.Cart do
  @moduledoc """
  Cart schema for Eshop application.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem

  @type t :: %Cart{}

  schema "carts" do
    field :session_key, :string
    has_many :items, CartItem

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(Cart.t(), map()) :: Ecto.Changeset.t()
  def changeset(%Cart{} = cart, attrs) do
    required_fields = [:session_key]

    cart
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
