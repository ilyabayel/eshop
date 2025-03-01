defmodule Eshop.Marketing.Schemas.PricingRule do
  @moduledoc """
  Pricing rule schema.

  Strategy options:
    - :buy_x_get_y_for_free - where x is quantity you need to buy and y is quantity you get for free
    - :discount_fixed - where x is lower limit you need to buy and y is price per product
    - :discount_percentage - where x is quantity you need to buy and y is discount in percents
  """
  use Ecto.Schema

  import Ecto.Changeset
  import PolymorphicEmbed

  alias Eshop.Marketing.Schemas.BuyXGetYStrategy
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.DiscountPercentageStrategy
  alias Eshop.Marketing.Schemas.PricingRule
  alias Eshop.Marketing.Schemas.PricingRuleProduct
  alias Eshop.Products.Schemas.Product

  @type t :: %PricingRule{}

  schema "pricing_rules" do
    field :name, :string
    field :description, :string

    polymorphic_embeds_one(:strategy,
      types: [
        buy_x_get_y: BuyXGetYStrategy,
        discount_percentage: DiscountPercentageStrategy,
        discount_fixed: DiscountFixedStrategy
      ],
      type_field_name: :type,
      on_type_not_found: :raise,
      on_replace: :update
    )

    many_to_many :products, Product, join_through: PricingRuleProduct

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(PricingRule.t(), map()) :: Ecto.Changeset.t()
  def changeset(%PricingRule{} = pricing_rule, attrs) do
    required_fields = [:name, :description]

    pricing_rule
    |> cast(attrs, required_fields)
    |> cast_polymorphic_embed(:strategy, required: true)
    |> validate_required(required_fields)
  end
end
