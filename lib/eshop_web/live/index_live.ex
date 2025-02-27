defmodule EshopWeb.IndexLive do
  @moduledoc """
  This is the index page live view.
  """

  use EshopWeb, :live_view

  import EshopWeb.Components.Cart
  import EshopWeb.Components.Navbar
  import EshopWeb.Components.ProductCard

  alias Eshop.Accounts

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background">
      <.navbar user={@user} />
      <main class="container mx-auto px-4 py-8">
        <div class="lg:grid lg:grid-cols-12 lg:gap-x-8">
          <div class="lg:col-span-7 xl:col-span-8">
            <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3">
              <.product_card :for={product <- @products} product={product} />
            </div>
          </div>
          <div class="lg:col-span-5 xl:col-span-4 relative">
            <.cart show_cart={true} cart_items={@cart_items} cart_summary={@cart_summary} />
          </div>
        </div>
      </main>
    </div>
    """
  end

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"] || "")

    products = [
      %{
        id: 1,
        title: "Coffee",
        price: %{
          currency_label: "£",
          value: Decimal.new("11.23")
        },
        special_offers: [
          %{
            label: "Special offer: 1+1",
            id: 1
          }
        ],
        image_url: "/images/coffee-beans.jpg",
        out_of_stock: false
      },
      %{
        id: 2,
        title: "Wireless Headphones",
        price: %{
          currency_label: "£",
          value: Decimal.new("199.99")
        },
        special_offers: [],
        image_url: "/images/headphones.jpg",
        out_of_stock: true
      },
      %{
        id: 3,
        title: "Smart Watch",
        price: %{
          currency_label: "£",
          value: Decimal.new("149.99")
        },
        special_offers: [],
        image_url: "/images/smart-watch.jpg",
        out_of_stock: true
      },
      %{
        id: 4,
        title: "Laptop Stand",
        price: %{
          currency_label: "£",
          value: Decimal.new("29.99")
        },
        special_offers: [],
        image_url: "/images/laptop-stand.jpg",
        out_of_stock: true
      },
      %{
        id: 5,
        title: "Wireless Mouse",
        price: %{
          currency_label: "£",
          value: Decimal.new("39.99")
        },
        special_offers: [],
        image_url: "/images/mx-master.webp",
        out_of_stock: true
      },
      %{
        id: 6,
        title: "Coffee Machine",
        price: %{
          currency_label: "£",
          value: Decimal.new("89.99")
        },
        special_offers: [],
        image_url: "/images/coffee-machine.jpg",
        out_of_stock: true
      },
      %{
        id: 7,
        title: "Strawberries",
        price: %{
          currency_label: "£",
          value: Decimal.new("5.00")
        },
        special_offers: [
          %{
            label: "£4.50 when buy 3+",
            id: 1
          }
        ],
        image_url: "/images/strawberries.png",
        out_of_stock: false
      },
      %{
        id: 8,
        title: "Green tea",
        price: %{
          currency_label: "£",
          value: Decimal.new("3.11")
        },
        special_offers: [
          %{
            label: "-33% when buy 3+",
            id: 1
          }
        ],
        image_url: "/images/green-tea.webp",
        out_of_stock: false
      }
    ]

    cart_items = [
      %{
        id: 1,
        title: "Coffee",
        price: %{
          currency_label: "£",
          value: Decimal.new("11.23")
        },
        quantity: 3,
        applied_discounts: [%{label: "Special offer: 1+1"}],
        total_without_discounts: Decimal.new("33.69"),
        total_with_discounts: Decimal.new("22.46"),
        image_url: "/images/coffee-beans.jpg"
      },
      %{
        id: 8,
        title: "Green tea",
        price: %{
          currency_label: "£",
          value: Decimal.new("3.11")
        },
        quantity: 2,
        applied_discounts: [],
        total_without_discounts: Decimal.new("6.22"),
        total_with_discounts: Decimal.new("6.22"),
        image_url: "/images/green-tea.webp"
      }
    ]

    cart_summary = calculate_cart_summary(cart_items)

    {:ok,
     assign(socket,
       user: user,
       products: Enum.sort_by(products, & &1.out_of_stock),
       cart_items: cart_items,
       cart_summary: cart_summary
     )}
  end

  defp calculate_cart_summary(cart_items) do
    %{total: total, subtotal: subtotal} =
      Enum.reduce(cart_items, %{total: Decimal.new("0"), subtotal: Decimal.new("0")}, fn item, totals ->
        %{
          total: Decimal.add(item.total_with_discounts, totals.total),
          subtotal: Decimal.add(item.total_without_discounts, totals.subtotal)
        }
      end)

    %{total: total, subtotal: subtotal, discount: Decimal.sub(subtotal, total), currency_label: "£"}
  end
end
