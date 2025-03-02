defmodule Eshop.CartAndCheckout.Structs.CartWithPrices do
  @moduledoc false
  use TypedStruct

  alias Eshop.CartAndCheckout.Structs.CartItemWithPrices

  typedstruct do
    field :id, String.t()
    field :items, list(CartItemWithPrices.t())
    field :subtotal, Money.t()
    field :total, Money.t()
    field :discount, Money.t()
  end
end
