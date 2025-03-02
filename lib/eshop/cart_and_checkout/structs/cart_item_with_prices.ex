defmodule Eshop.CartAndCheckout.Structs.CartItemWithPrices do
  @moduledoc false
  use TypedStruct

  alias Eshop.Products.Schemas.Product

  typedstruct do
    field :id, String.t()
    field :product, Product.t()
    field :quantity, integer()
    field :subtotal, Money.t()
    field :total, Money.t()
  end
end
