defmodule Eshop.CartAndCheckout.Services.FetchCartWithPricesTest do
  use Eshop.DataCase, async: true

  alias Eshop.CartAndCheckout
  alias Eshop.Marketing.Schemas.BuyXGetYStrategy
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.DiscountPercentageStrategy

  describe "call/2" do
    test "should calculate cart totals without pricing rules" do
      %{id: cart_id} = cart = F.insert(:cart)
      item_1 = F.insert(:cart_item, cart: cart, product: F.build(:product, price: Money.new(6_00)), quantity: 1)
      item_2 = F.insert(:cart_item, cart: cart, product: F.build(:product, price: Money.new(4_00)), quantity: 2)
      item_3 = F.insert(:cart_item, cart: cart, product: F.build(:product, price: Money.new(1_00)), quantity: 3)

      assert {:ok,
              %{
                id: ^cart_id,
                items: items,
                subtotal: %Money{amount: 17_00, currency: :GBP},
                total: %Money{amount: 17_00, currency: :GBP}
              }} = CartAndCheckout.get_cart_with_prices(cart)

      assert %{subtotal: %Money{amount: 6_00, currency: :GBP}, total: %Money{amount: 6_00, currency: :GBP}} =
               Enum.find(items, &(&1.id == item_1.id))

      assert %{subtotal: %Money{amount: 8_00, currency: :GBP}, total: %Money{amount: 8_00, currency: :GBP}} =
               Enum.find(items, &(&1.id == item_2.id))

      assert %{subtotal: %Money{amount: 3_00, currency: :GBP}, total: %Money{amount: 3_00, currency: :GBP}} =
               Enum.find(items, &(&1.id == item_3.id))
    end

    test "should calculate cart totals with pricing rules" do
      {%{id: cart_id} = cart, items_map} = setup_cart_with_pricing_rules(3, 1, 1)

      assert {:ok,
              %{
                id: ^cart_id,
                items: items,
                subtotal: %Money{amount: 25_56, currency: :GBP},
                total: %Money{amount: 22_45, currency: :GBP}
              }} = CartAndCheckout.get_cart_with_prices(cart)

      assert %{subtotal: %Money{amount: 9_33, currency: :GBP}, total: %Money{amount: 6_22, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.green_tea.id))

      assert %{subtotal: %Money{amount: 5_00, currency: :GBP}, total: %Money{amount: 5_00, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.strawberries.id))

      assert %{subtotal: %Money{amount: 11_23, currency: :GBP}, total: %Money{amount: 11_23, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.coffee.id))
    end

    test "should calculate cart totals with pricing rules case 2" do
      {%{id: cart_id} = cart, items_map} = setup_cart_with_pricing_rules(2, 0, 0)

      assert {:ok,
              %{
                id: ^cart_id,
                items: items,
                subtotal: %Money{amount: 6_22, currency: :GBP},
                total: %Money{amount: 3_11, currency: :GBP}
              }} = CartAndCheckout.get_cart_with_prices(cart)

      assert %{subtotal: %Money{amount: 6_22, currency: :GBP}, total: %Money{amount: 3_11, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.green_tea.id))
    end

    test "should calculate cart totals with pricing rules case 3" do
      {%{id: cart_id} = cart, items_map} = setup_cart_with_pricing_rules(1, 3, 0)

      assert {:ok,
              %{
                id: ^cart_id,
                items: items,
                subtotal: %Money{amount: 18_11, currency: :GBP},
                total: %Money{amount: 16_61, currency: :GBP}
              }} = CartAndCheckout.get_cart_with_prices(cart)

      assert %{subtotal: %Money{amount: 3_11, currency: :GBP}, total: %Money{amount: 3_11, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.green_tea.id))

      assert %{subtotal: %Money{amount: 15_00, currency: :GBP}, total: %Money{amount: 13_50, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.strawberries.id))
    end

    test "should calculate cart totals with pricing rules [case 3]" do
      {%{id: cart_id} = cart, items_map} = setup_cart_with_pricing_rules(1, 1, 3)

      assert {:ok,
              %{
                id: ^cart_id,
                items: items,
                subtotal: %Money{amount: 41_80, currency: :GBP},
                total: %Money{amount: 30_57, currency: :GBP}
              }} = CartAndCheckout.get_cart_with_prices(cart)

      assert %{subtotal: %Money{amount: 3_11, currency: :GBP}, total: %Money{amount: 3_11, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.green_tea.id))

      assert %{subtotal: %Money{amount: 5_00, currency: :GBP}, total: %Money{amount: 5_00, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.strawberries.id))

      assert %{subtotal: %Money{amount: 33_69, currency: :GBP}, total: %Money{amount: 22_46, currency: :GBP}} =
               Enum.find(items, &(&1.id == items_map.coffee.id))
    end
  end

  defp setup_cart_with_pricing_rules(green_tea_quantity, strawberries_quantity, coffee_quantity) do
    cart = F.insert(:cart)

    green_tea =
      F.insert(:cart_item,
        cart: cart,
        product:
          F.build(:product,
            price: Money.new(3_11),
            pricing_rules: [
              F.build(:pricing_rule,
                name: "Buy 1 get 1",
                description: "Buy 1 get 1 free",
                strategy: %BuyXGetYStrategy{type: "buy_x_get_y", buy_quantity: 1, get_quantity: 1}
              )
            ]
          ),
        quantity: green_tea_quantity
      )

    strawberries =
      F.insert(:cart_item,
        cart: cart,
        product:
          F.build(:product,
            price: Money.new(5_00),
            pricing_rules: [
              F.build(:pricing_rule,
                name: "Buy for £4.50 per item",
                description: "Buy for £4.50 if buy 3 or more",
                strategy: %DiscountFixedStrategy{type: "discount_fixed", minimum_quantity: 3, discount: Money.new(0_50)}
              )
            ]
          ),
        quantity: strawberries_quantity
      )

    coffee =
      F.insert(:cart_item,
        cart: cart,
        product:
          F.build(:product,
            price: Money.new(11_23),
            pricing_rules: [
              F.build(:pricing_rule,
                name: "Save 1/3 of the price",
                description: "Save 1/3 of the price if buy 3 or more",
                strategy: %DiscountPercentageStrategy{
                  type: "discount_percentage",
                  minimum_quantity: 3,
                  discount_percentage: Decimal.div(1 * 100, 3)
                }
              )
            ]
          ),
        quantity: coffee_quantity
      )

    {cart, %{green_tea: green_tea, strawberries: strawberries, coffee: coffee}}
  end
end
