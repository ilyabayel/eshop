defmodule Eshop.CartAndCheckout.Services.ApplyStrategy do
  @moduledoc false
  alias Eshop.Marketing.Schemas.BuyXGetYStrategy
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.DiscountPercentageStrategy

  def call(strategy, item, subtotal) do
    apply_strategy(strategy, item, subtotal)
  end

  defp apply_strategy(%DiscountFixedStrategy{} = strategy, item, subtotal) do
    if item.quantity >= strategy.minimum_quantity do
      total_discount = Money.multiply(strategy.discount, item.quantity)
      Money.subtract(subtotal, total_discount)
    else
      subtotal
    end
  end

  defp apply_strategy(%DiscountPercentageStrategy{} = strategy, item, subtotal) do
    if item.quantity >= strategy.minimum_quantity do
      discount = Money.multiply(subtotal, Decimal.div(strategy.discount_percentage, 100))

      Money.subtract(subtotal, discount)
    else
      subtotal
    end
  end

  defp apply_strategy(%BuyXGetYStrategy{} = strategy, item, subtotal) do
    get_for_free = div(item.quantity, strategy.buy_quantity + strategy.get_quantity)

    Money.subtract(subtotal, Money.multiply(item.product.price, get_for_free))
  end
end
