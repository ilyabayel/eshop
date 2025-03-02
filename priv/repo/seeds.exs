# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eshop.Repo.insert!(%Eshop.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Eshop.Marketing
alias Eshop.Marketing.Schemas.PricingRuleProduct
alias Eshop.Products
alias Eshop.Repo

products = [
  %{
    title: "Green tea",
    code: "GR1",
    description: "A refreshing green tea",
    image_url: "/images/green-tea.webp",
    price: Money.new(3_11),
    stock: 100,
    pricing_rules: [
      %{name: "Special offer: 1+1", strategy: %{type: "buy_x_get_y", buy_quantity: 1, get_quantity: 1}}
    ]
  },
  %{
    title: "Strawberries",
    code: "SR1",
    description: "Fresh, juicy strawberries",
    image_url: "/images/strawberries.png",
    price: Money.new(5_00),
    stock: 100,
    pricing_rules: [
      %{
        name: "£4.50 per item if buy 3+",
        strategy: %{type: "discount_fixed", minimum_quantity: 3, discount: Money.new(0_50)}
      }
    ]
  },
  %{
    title: "Coffee",
    code: "CF1",
    description: "A rich and aromatic coffee",
    image_url: "/images/coffee-beans.jpg",
    price: Money.new(11_23),
    stock: 100,
    pricing_rules: [
      %{
        name: "Discount 33% if buy 3+",
        strategy: %{type: "discount_percentage", minimum_quantity: 3, discount_percentage: Decimal.div(1 * 100, 3)}
      }
    ]
  },
  %{
    title: "Wireless Headphones",
    code: "WH1",
    description: "High-quality wireless headphones with noise cancellation",
    image_url: "/images/headphones.jpg",
    price: Money.new(19_995),
    stock: 0,
    pricing_rules: []
  },
  %{
    title: "Smart Watch",
    code: "SW1",
    description: "Feature-rich smart watch with health monitoring",
    image_url: "/images/smart-watch.jpg",
    price: Money.new(94_99),
    stock: 0,
    pricing_rules: []
  },
  %{
    title: "Laptop Stand",
    code: "LS1",
    description: "Ergonomic laptop stand for improved comfort",
    image_url: "/images/laptop-stand.jpg",
    price: Money.new(49_99),
    stock: 0,
    pricing_rules: []
  },
  %{
    title: "Wireless Mouse",
    code: "WM1",
    description: "Precision wireless mouse for productivity",
    image_url: "/images/mx-master.webp",
    price: Money.new(59_99),
    stock: 0,
    pricing_rules: []
  },
  %{
    title: "Coffee Machine",
    code: "CM1",
    description: "Automated coffee machine for perfect brews",
    image_url: "/images/coffee-machine.jpg",
    price: Money.new(18_999),
    stock: 0,
    pricing_rules: []
  }
]

for product <- products do
  {:ok, %{id: product_id}} =
    Products.CRUD.create_product(%{
      title: product.title,
      code: product.code,
      price: product.price,
      stock: product.stock,
      description: product.description,
      image_url: product.image_url
    })

  for pricing_rule <- product.pricing_rules do
    {:ok, %{id: pricing_rule_id}} =
      Marketing.CRUD.create_pricing_rule(%{
        name: pricing_rule.name,
        description: "any",
        strategy: pricing_rule.strategy
      })

    Repo.insert!(%PricingRuleProduct{product_id: product_id, pricing_rule_id: pricing_rule_id})
  end
end
