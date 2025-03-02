defmodule Eshop.Factory do
  # with Ecto
  @moduledoc false
  use Eshop.ExMachinaPolymorphicEmbed.Ecto, repo: Eshop.Repo

  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartItem
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.PricingRule
  alias Eshop.Products.Schemas.Product

  def product_factory do
    %Product{
      title: sequence(:title, &"product-#{&1}"),
      description: sequence(:description, &"description of product-#{&1}"),
      code: sequence(:code, &"PR#{&1}"),
      image_url: "/images/product.jpg",
      price: Money.new(1_00, :GBP),
      stock: 1
    }
  end

  def cart_factory do
    %Cart{
      session_key: "session_key"
    }
  end

  def pricing_rule_factory do
    %PricingRule{
      name: sequence(:name, &"Pricing Rule #{&1}"),
      description: sequence(:description, &"Description for pricing rule #{&1}"),
      # To support polymorphic embeds
      # you need to pass struct a as parameter
      strategy: %DiscountFixedStrategy{
        type: "discount_fixed",
        minimum_quantity: 1,
        discount: Money.new(10, :GBP)
      }
    }
  end

  def cart_item_factory do
    %CartItem{
      quantity: sequence(:quantity, &(1 + &1)),
      product: build(:product),
      cart: build(:cart)
    }
  end
end
