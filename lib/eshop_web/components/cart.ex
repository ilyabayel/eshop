defmodule EshopWeb.Components.Cart do
  @moduledoc false
  use EshopWeb, :component

  attr :cart, :map, required: true

  def cart(assigns) do
    ~H"""
    <div class="bg-background border rounded-xl h-min">
      <div class="flex flex-col">
        <div class="p-4 border-b flex justify-between items-center">
          <h2 class="text-lg font-semibold">Shopping Cart</h2>
          <button class="text-muted-foreground hover:text-foreground" phx-click="toggle_cart">
            <.icon name="hero-x-mark" class="h-6 w-6" />
          </button>
        </div>

        <div class="flex-1 overflow-y-auto p-4 max-h-[500px]">
          <div
            :if={Enum.empty?(@cart.items)}
            class="flex flex-col items-center justify-center h-full text-muted-foreground"
          >
            <.icon name="hero-shopping-cart" class="h-12 w-12 mb-4" />
            <p>Your cart is empty</p>
          </div>
          <div class="space-y-4">
            <div
              :for={item <- @cart.items}
              class="flex items-start space-x-4 py-4 border-b last:border-none"
            >
              <img src={item.image_url} alt={item.title} class="h-20 w-20 object-cover rounded-md" />
              <div class="flex-1">
                <h3 class="font-medium">{item.title}</h3>
                <p class="text-sm text-muted-foreground">
                  {item.price.currency_label}{item.price.value} × {item.quantity}
                </p>
                <span :for={discount <- item.applied_discounts} class="text-sm text-destructive">
                  {discount.label}
                </span>
              </div>
              <div class="flex flex-col items-end space-y-2">
                <p>
                  <span
                    :if={not Enum.empty?(item.applied_discounts)}
                    class="text-muted-foreground line-through text-sm mr-1"
                  >
                    {item.price.currency_label}{item.total_without_discounts}
                  </span>
                  <span class="font-medium">
                    {item.price.currency_label}{item.total_with_discounts}
                  </span>
                </p>
                <div class="flex items-center text-sm">
                  <button
                    class="w-6 h-6 hover:bg-accent rounded-full flex items-center justify-center"
                    phx-click="decrease_quantity"
                    phx-value-id={item.id}
                  >
                    <.icon name="hero-minus-small" class="h-5 w-5" />
                  </button>
                  <span class="w-8 text-center">{item.quantity}</span>
                  <button
                    class="w-6 h-6 hover:bg-accent rounded-full flex items-center justify-center"
                    phx-click="increase_quantity"
                    phx-value-id={item.id}
                  >
                    <.icon name="hero-plus-small" class="h-5 w-5" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="border-t p-4 space-y-4">
          <div class="space-y-2">
            <div class="flex justify-between text-sm">
              <span class="text-muted-foreground">Subtotal</span>
              <span>{Money.to_string(@cart.subtotal)}</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-muted-foreground">Discounts</span>
              <span class="text-destructive">
                -{Money.to_string(@cart.discount)}
              </span>
            </div>
            <div class="flex justify-between font-medium">
              <span>Total</span>
              <span>{Money.to_string(@cart.total)}</span>
            </div>
          </div>
          <.button class="w-full" disabled={Enum.empty?(@cart.items)}>
            Checkout
          </.button>
        </div>
      </div>
    </div>
    """
  end
end
