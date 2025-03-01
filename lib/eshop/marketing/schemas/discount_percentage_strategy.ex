defmodule Eshop.Marketing.Schemas.DiscountPercentageStrategy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:type, :discount_percentage, :minimum_quantity]

  @primary_key false

  embedded_schema do
    field :type, :string
    field :discount_percentage, :integer
    field :minimum_quantity, :integer
  end

  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:discount_percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:minimum_quantity, greater_than: 0)
  end
end
