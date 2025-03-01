defmodule Eshop.Products.Schemas.Product do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.Marketing.Schemas.PricingRule
  alias Eshop.Marketing.Schemas.PricingRuleProduct
  alias Eshop.Products.Schemas.Product

  @type t :: %Product{}

  schema "products" do
    field :title, :string
    field :description, :string
    field :image_url, :string
    field :price, Money.Ecto.Composite.Type
    field :stock, :integer

    many_to_many :pricing_rules, PricingRule, join_through: PricingRuleProduct

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(Product.t(), map()) :: Ecto.Changeset.t()
  def changeset(product, attrs) do
    required_fields = [:title, :image_url, :price, :stock]
    optional_fields = [:description]

    product
    |> cast(attrs, optional_fields ++ required_fields)
    |> validate_required(required_fields)
  end
end
