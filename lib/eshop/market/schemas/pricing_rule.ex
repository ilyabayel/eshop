defmodule Eshop.Market.Schemas.PricingRule do
  @moduledoc """
  Pricing rule schema.

  Strategy options:
    - :buy_x_get_y_for_free - where x is quantity you need to buy and y is quantity you get for free
    - :buy_x_for_y_price - where x is lower limit you need to buy and y is price per product
    - :buy_x_with_y_discount - where x is quantity you need to buy and y is discount in percents
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Eshop.Market.Schemas.PricingRule
  alias Eshop.Market.Schemas.Product

  @type t :: %PricingRule{}

  @required_fields [:name, :description, :strategy, :strategy_variables]

  schema "pricing_rules" do
    field :name, :string
    field :description, :string
    field :strategy, Ecto.Enum, values: [:discount_percentage, :discount_fixed, :buy_x_get_y]

    # This field holds the variables required for each strategy
    # For example:
    # - :discount_percentage => %{minimum_quantity: 0, percentage: 10}
    # - :discount_fixed => %{minimum_quantity: 0, discount: Money.new(1_00, :GBP)}
    # - :buy_x_get_y => %{x: 0, y: 0}
    field :strategy_variables, :map

    many_to_many :products, Product, join_through: "pricing_rules_products"

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(PricingRule.t(), map()) :: Ecto.Changeset.t()
  def changeset(%PricingRule{} = pricing_rule, attrs) do
    pricing_rule
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
