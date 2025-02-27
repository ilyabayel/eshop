defmodule Eshop.Market.Schemas.CartProduct do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.Market.Schemas.Cart
  alias Eshop.Market.Schemas.CartProduct
  alias Eshop.Market.Schemas.Product

  @type t :: %CartProduct{}

  @required_fields [:quantity, :product_id, :cart_id]

  schema "cart_products" do
    field :quantity, :integer
    belongs_to :product, Product
    belongs_to :cart, Cart

    timestamps()
  end

  @spec changeset(CartProduct.t(), map()) :: Ecto.Changeset.t()
  def changeset(cart_product, attrs) do
    cart_product
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
