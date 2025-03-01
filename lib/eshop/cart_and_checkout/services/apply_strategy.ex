defmodule Eshop.CartAndCheckout.Services.ApplyStrategy do
  @moduledoc false
  alias Eshop.Marketing.Schemas.BuyXGetYStrategy
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.DiscountPercentageStrategy

  def call(strategy, item, total) do
    apply_strategy(strategy, item, total)
  end

  defp apply_strategy(%DiscountFixedStrategy{} = strategy, item, total) do
    if item.quantity >= strategy.minimum_quantity do
      total_discount = Money.multiply(strategy.discount, item.quantity)
      Money.subtract(total, total_discount)
    else
      total
    end
  end

  defp apply_strategy(%DiscountPercentageStrategy{} = strategy, item, total) do
    if item.quantity >= strategy.minimum_quantity do
      discount = Money.multiply(total, Decimal.div(strategy.discount_percentage, 100))

      Money.subtract(total, discount)
    else
      total
    end
  end

  defp apply_strategy(%BuyXGetYStrategy{} = strategy, item, total) do
    get_for_free = div(item.quantity, strategy.buy_quantity + strategy.get_quantity)

    Money.subtract(total, Money.multiply(item.product.price, get_for_free))
  end
end
