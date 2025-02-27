defmodule EshopWeb.Components.ProductCard do
  @moduledoc false
  use EshopWeb, :component

  import EshopWeb.Components.Card

  attr :product, :map, required: true

  def product_card(assigns) do
    ~H"""
    <.card class="flex flex-col justify-between">
      <.card_header>
        <img
          src={@product.image_url}
          alt="Product image"
          class="h-full w-full object-contain object-center group-hover:opacity-75 aspect-video"
        />
        <.card_title>{@product.title}</.card_title>
      </.card_header>
      <.card_content>
        <p :for={offer <- @product.special_offers} class="text-red-500">
          {offer.label}
        </p>
      </.card_content>
      <.card_footer>
        <p class="text-lg font-semibold text-foreground">
          {@product.price.currency_label}{@product.price.value}
        </p>
        <.button :if={not @product.out_of_stock}>
          Add to cart <Lucide.plus class="h-5 w-5 ml-2" />
        </.button>
        <.button :if={@product.out_of_stock} variant="outline" disabled>
          Out of stock
        </.button>
      </.card_footer>
    </.card>
    """
  end
end
