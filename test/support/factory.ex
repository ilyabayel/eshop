defmodule Eshop.Factory do
  # with Ecto
  @moduledoc false
  use ExMachina.Ecto, repo: Eshop.Repo

  alias Eshop.Accounts.User
  alias Eshop.Market.Schemas.Cart
  alias Eshop.Market.Schemas.CartProduct
  alias Eshop.Market.Schemas.PricingRule
  alias Eshop.Market.Schemas.Product

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
      price_amount: 1_00,
      price_currency: :GBP,
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
      strategy:
        sequence(:strategy, fn i ->
          Enum.at([:discount_percentage, :discount_fixed, :buy_x_get_y], rem(i, 3))
        end),
      strategy_variables:
        sequence(:strategy_variables, fn i ->
          case rem(i, 3) do
            0 -> %{minimum_quantity: 2, percentage: 10}
            1 -> %{minimum_quantity: 3, discount: 500}
            2 -> %{x: 2, y: 1}
          end
        end)
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
