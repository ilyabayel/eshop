defmodule Eshop.Market.Schemas.Product do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.Market.Schemas.Cart
  alias Eshop.Market.Schemas.CartProduct
  alias Eshop.Market.Schemas.PricingRule
  alias Eshop.Market.Schemas.Product

  @type t :: %Product{}

  @required_fields [:title, :image_url, :price_amount, :price_currency, :stock]
  @optional_fields [:description]

  schema "products" do
    field :title, :string
    field :description, :string
    field :image_url, :string
    field :price_amount, Money.Ecto.Amount.Type
    field :price_currency, Money.Ecto.Currency.Type
    field :stock, :integer

    many_to_many :pricing_rules, PricingRule, join_through: "pricing_rules_products"
    many_to_many :carts, Cart, join_through: CartProduct

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(Product.t(), map()) :: Ecto.Changeset.t()
  def changeset(product, attrs) do
    product
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
