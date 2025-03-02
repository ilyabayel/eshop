defmodule Eshop.CartAndCheckout.Services.AddProductToCartTest do
  use Eshop.DataCase, async: true

  alias Eshop.CartAndCheckout
  alias Eshop.Marketing.Schemas.BuyXGetYStrategy
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.DiscountPercentageStrategy

  describe "call/3" do
    test "adds a product to an empty cart" do
      cart = F.insert(:cart)
      product = F.insert(:product, price: Money.new(5_00))

      assert {:ok, result} = CartAndCheckout.add_product_to_cart(cart.id, product.id, 1)

      assert result.id == cart.id
      assert length(result.items) == 1
      assert result.subtotal == Money.new(5_00)
      assert result.total == Money.new(5_00)
      assert result.discount == Money.new(0)

      [item] = result.items
      assert item.product.id == product.id
      assert item.quantity == 1
      assert item.subtotal == Money.new(5_00)
      assert item.total == Money.new(5_00)
    end

    test "increases quantity when adding a product already in the cart" do
      cart = F.insert(:cart)
      product = F.insert(:product, price: Money.new(5_00))

      # First add
      {:ok, _} = CartAndCheckout.add_product_to_cart(cart.id, product.id, 1)

      # Second add
      {:ok, result} = CartAndCheckout.add_product_to_cart(cart.id, product.id, 2)

      assert result.subtotal == Money.new(15_00)
      assert result.total == Money.new(15_00)

      [item] = result.items
      assert item.product.id == product.id
      assert item.quantity == 3
      assert item.subtotal == Money.new(15_00)
      assert item.total == Money.new(15_00)
    end

    test "removes product when quantity would become zero" do
      product1 = F.insert(:product, price: Money.new(5_00))
      product2 = F.insert(:product, price: Money.new(3_00))

      cart = F.insert(:cart)

      F.insert(:cart_item, product: product1, quantity: 1, cart: cart)
      F.insert(:cart_item, product: product2, quantity: 2, cart: cart)

      {:ok, cart} = CartAndCheckout.remove_product_from_cart(cart.id, product1.id)

      assert length(cart.items) == 1
      assert cart.subtotal == Money.new(6_00)
      assert cart.total == Money.new(6_00)

      [item] = cart.items
      assert item.product.id == product2.id
    end

    test "applies pricing rules correctly when adding products" do
      cart = F.insert(:cart)

      # Product with buy 1 get 1 free rule
      green_tea =
        F.insert(:product,
          price: Money.new(3_11),
          pricing_rules: [
            F.build(:pricing_rule,
              name: "Buy 1 get 1",
              description: "Buy 1 get 1 free",
              strategy: %BuyXGetYStrategy{type: "buy_x_get_y", buy_quantity: 1, get_quantity: 1}
            )
          ]
        )

      # Product with fixed discount rule
      strawberries =
        F.insert(:product,
          price: Money.new(5_00),
          pricing_rules: [
            F.build(:pricing_rule,
              name: "Buy for £4.50 per item",
              description: "Buy for £4.50 if buy 3 or more",
              strategy: %DiscountFixedStrategy{type: "discount_fixed", minimum_quantity: 3, discount: Money.new(0_50)}
            )
          ]
        )

      # Add 2 green tea (should apply buy 1 get 1 free)
      {:ok, result1} = CartAndCheckout.add_product_to_cart(cart.id, green_tea.id, 2)

      assert result1.subtotal == Money.new(6_22)
      assert result1.total == Money.new(3_11)
      assert result1.discount == Money.new(3_11)

      # Add 3 strawberries (should get fixed discount)
      {:ok, result2} = CartAndCheckout.add_product_to_cart(cart.id, strawberries.id, 3)

      # 6.22 + 15.00
      assert result2.subtotal == Money.new(21_22)
      # 3.11 + 13.50
      assert result2.total == Money.new(16_61)
      # 3.11 + 1.50
      assert result2.discount == Money.new(4_61)

      # Check the individual items
      green_tea_item = Enum.find(result2.items, &(&1.product.id == green_tea.id))
      strawberries_item = Enum.find(result2.items, &(&1.product.id == strawberries.id))

      assert green_tea_item.quantity == 2
      assert green_tea_item.subtotal == Money.new(6_22)
      assert green_tea_item.total == Money.new(3_11)

      assert strawberries_item.quantity == 3
      assert strawberries_item.subtotal == Money.new(15_00)
      assert strawberries_item.total == Money.new(13_50)
    end

    test "handles percentage discount correctly" do
      cart = F.insert(:cart)

      coffee =
        F.insert(:product,
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
        )

      {:ok, result} = CartAndCheckout.add_product_to_cart(cart.id, coffee.id, 3)

      assert result.subtotal == Money.new(33_69)
      assert result.total == Money.new(22_46)
      assert result.discount == Money.new(11_23)

      [coffee_item] = result.items
      assert coffee_item.quantity == 3
      assert coffee_item.subtotal == Money.new(33_69)
      assert coffee_item.total == Money.new(22_46)
    end

    test "returns error when cart doesn't exist" do
      product = F.insert(:product)

      assert {:error, "Cart not found"} = CartAndCheckout.add_product_to_cart(999, product.id, 1)
    end

    test "returns error when product doesn't exist" do
      cart = F.insert(:cart)

      assert {:error, "Product not found"} = CartAndCheckout.add_product_to_cart(cart.id, 999, 1)
    end
  end
end
