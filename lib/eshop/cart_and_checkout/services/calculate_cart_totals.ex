defmodule Eshop.CartAndCheckout.Services.CalculateCartTotals do
  @moduledoc """
  """
  import Ecto.Query, only: [from: 2]

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.CartAndCheckout.Services.ApplyStrategy

  def call(%Cart{} = cart) do
    items =
      cart
      |> get_cart_items()
      |> apply_pricing_rules()

    prepare_cart(cart, items, calculate_totals(items))
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
      total = calculate_total_for_item(item, subtotal)

      item
      |> Map.put(:total, total)
      |> Map.put(:subtotal, subtotal)
    end
  end

  defp calculate_total_for_item(item, subtotal) do
    {total, _} =
      Enum.reduce(item.product.pricing_rules, {subtotal, item}, fn pricing_rule, {total, item} ->
        total = ApplyStrategy.call(pricing_rule.strategy, item, total)

        {total, item}
      end)

    total
  end

  defp calculate_totals(items) do
    acc = %{subtotal: Money.new(0), total: Money.new(0)}

    Enum.reduce(items, acc, fn item, acc ->
      %{subtotal: subtotal, total: total} = acc
      %{subtotal: Money.add(subtotal, item.subtotal), total: Money.add(total, item.total)}
    end)
  end

  defp prepare_cart(cart, items, %{subtotal: subtotal, total: total}) do
    {:ok, %{id: cart.id, items: items, subtotal: subtotal, total: total}}
  end
end
