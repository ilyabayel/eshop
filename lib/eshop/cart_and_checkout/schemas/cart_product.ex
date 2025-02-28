defmodule Eshop.CartAndCheckout.Schemas.CartProduct do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartProduct
  alias Eshop.Products.Schemas.Product

  @type t :: %CartProduct{}

  schema "cart_products" do
    field :quantity, :integer
    belongs_to :product, Product
    belongs_to :cart, Cart

    timestamps()
  end

  @spec changeset(CartProduct.t(), map()) :: Ecto.Changeset.t()
  def changeset(cart_product, attrs) do
    required_fields = [:quantity, :product_id, :cart_id]

    cart_product
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
