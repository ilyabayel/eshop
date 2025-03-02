defmodule Eshop.Marketing.Schemas.BuyXGetYStrategy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  embedded_schema do
    field :type, :string
    field :buy_quantity, :integer
    field :get_quantity, :integer
  end

  def changeset(strategy, attrs) do
    required_fields = [:type, :buy_quantity, :get_quantity]

    strategy
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_number(:buy_quantity, greater_than: 0)
    |> validate_number(:get_quantity, greater_than: 0)
  end
end
