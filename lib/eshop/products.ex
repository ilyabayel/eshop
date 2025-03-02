defmodule Eshop.Products do
  @moduledoc """
  Provides functions for managing products in the Eshop application.
  """

  alias Eshop.Products.CRUD

  defdelegate fetch_product(id), to: CRUD
  defdelegate list_products, to: CRUD
  defdelegate create_product(attrs), to: CRUD
  defdelegate update_product(product, attrs), to: CRUD
  defdelegate delete_product(id), to: CRUD
end
