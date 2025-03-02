defmodule Eshop.CartAndCheckout.Structs.CartWithPrices do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :id, String.t()
    field :items, list(Eshop.CartAndCheckout.Structs.CartItemWithPrices.t())
    field :subtotal, Money.t()
    field :total, Money.t()
    field :discount, Money.t()
  end
end
