defmodule Eshop.Marketing.Schemas.DiscountFixedStrategy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:type, :discount, :minimum_quantity]

  embedded_schema do
    field :type, :string
    field :discount, Money.Ecto.Composite.Type
    field :minimum_quantity, :integer
  end

  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:minimum_quantity, greater_than: 0)
  end
end
