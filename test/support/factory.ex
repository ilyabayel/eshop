defmodule Eshop.Factory do
  # with Ecto
  @moduledoc false
  use Eshop.ExMachinaPolymorphicEmbed.Ecto, repo: Eshop.Repo

  alias Eshop.Accounts.User
  alias Eshop.CartAndCheckout.Schemas.Cart
  alias Eshop.CartAndCheckout.Schemas.CartProduct
  alias Eshop.Marketing.Schemas.DiscountFixedStrategy
  alias Eshop.Marketing.Schemas.PricingRule
  alias Eshop.Products.Schemas.Product

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: "hashed_password"
    }
  end

  def market_product_factory do
    %Product{
      title: sequence(:title, &"product-#{&1}"),
      description: sequence(:description, &"description of product-#{&1}"),
      image_url: "/images/product.jpg",
      price: Money.new(1_00, :GBP),
      stock: 1
    }
  end

  def cart_factory do
    %Cart{
      user: build(:user)
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

  def cart_product_factory do
    %CartProduct{
      quantity: sequence(:quantity, &(1 + &1)),
      product: build(:market_product),
      cart: build(:cart)
    }
  end
end
