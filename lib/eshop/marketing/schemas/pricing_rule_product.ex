defmodule Eshop.Marketing.Schemas.PricingRuleProduct do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "pricing_rules_products" do
    belongs_to :product, Eshop.Products.Schemas.Product
    belongs_to :pricing_rule, Eshop.Marketing.Schemas.PricingRule

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    required_fields = [:product_id, :pricing_rule_id]

    struct
    |> cast(params, required_fields)
    |> validate_required(required_fields)
  end
end
