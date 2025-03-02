defmodule Eshop.CartAndCheckout.Services.FetchCartWithPrices do
  @moduledoc """
  """
  import Ecto.Query, only: [from: 2]

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.CartAndCheckout.Services.ApplyStrategy
  alias Eshop.CartAndCheckout.Structs.CartItemWithPrices
  alias Eshop.CartAndCheckout.Structs.CartWithPrices

  @spec call(cart :: Cart.t()) :: {:ok, CartWithPrices.t()}
  def call(cart) do
    items =
      cart
      |> get_cart_items()
      |> apply_pricing_rules()

    %{subtotal: subtotal, total: total} = calcualte_cart_total_and_subtotal(items)

    {:ok,
     %CartWithPrices{
       id: cart.id,
       items: Enum.sort_by(items, & &1.id),
       subtotal: subtotal,
       total: total,
       discount: Money.subtract(subtotal, total)
     }}
  end

  defp get_cart_items(cart) do
    query =
      from(cart_item in CartItem,
        where: cart_item.cart_id == ^cart.id,
        preload: [product: :pricing_rules]
      )

    Eshop.Repo.all(query)
  end

  defp apply_pricing_rules(items) do
    for item <- items do
      subtotal = Money.multiply(item.product.price, item.quantity)
      total = calculate_item_total(item, subtotal)

      %CartItemWithPrices{
        id: item.id,
        product: item.product,
        quantity: item.quantity,
        subtotal: subtotal,
        total: total
      }
    end
  end

  defp calculate_item_total(item, subtotal) do
    Enum.reduce(item.product.pricing_rules, subtotal, fn pricing_rule, subtotal ->
      ApplyStrategy.call(pricing_rule.strategy, item, subtotal)
    end)
  end

  defp calcualte_cart_total_and_subtotal(items) do
    default_acc = %{subtotal: Money.new(0), total: Money.new(0)}

    Enum.reduce(items, default_acc, fn item, acc ->
      %{subtotal: Money.add(acc.subtotal, item.subtotal), total: Money.add(acc.total, item.total)}
    end)
  end
end
