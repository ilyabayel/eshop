defmodule Eshop.Marketing.Schemas.DiscountFixedStrategy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  embedded_schema do
    field :type, :string
    field :discount, Money.Ecto.Composite.Type
    field :minimum_quantity, :integer
  end

  def changeset(strategy, attrs) do
    required_fields = [:type, :discount, :minimum_quantity]

    strategy
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_number(:minimum_quantity, greater_than: 0)
  end
end
