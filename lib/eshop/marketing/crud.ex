defmodule Eshop.Marketing.CRUD do
  @moduledoc false

  alias Eshop.Marketing.Schemas.PricingRule
  alias Eshop.Repo

  def fetch_pricing_rule(id) do
    Repo.fetch(PricingRule, id)
  end

  def create_pricing_rule(attrs) do
    %PricingRule{}
    |> PricingRule.changeset(attrs)
    |> Repo.insert()
  end

  def delete_pricing_rule(id) do
    case fetch_pricing_rule(id) do
      {:ok, pricing_rule} ->
        Repo.delete(pricing_rule)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
