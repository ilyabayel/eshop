defmodule Eshop.CartAndCheckout.Schemas.CartItem do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.Products.Schemas.Product

  @type t :: %CartItem{}

  schema "cart_items" do
    field :quantity, :integer
    belongs_to :product, Product
    belongs_to :cart, Cart

    timestamps()
  end

  @spec changeset(CartItem.t(), map()) :: Ecto.Changeset.t()
  def changeset(cart_item, attrs) do
    required_fields = [:quantity, :product_id, :cart_id]

    cart_item
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
