defmodule Eshop.CartAndCheckout do
  @moduledoc false

  alias Eshop.CartAndCheckout.Services.AddItemAndCalculatePrices
  alias Eshop.CartAndCheckout.Services.GetCartWithPrices

  defdelegate add_item_and_calcualte_prices(cart, product), to: AddItemAndCalculatePrices, as: :call
  defdelegate get_cart_with_prices(cart_id), to: GetCartWithPrices, as: :call
end
