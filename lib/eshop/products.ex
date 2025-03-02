defmodule Eshop.Products do
  @moduledoc """
  Provides functions for managing products in the Eshop application.
  """

  alias Eshop.Products.CRUD

  defdelegate list, to: CRUD
  defdelegate create(attrs), to: CRUD
  defdelegate update(product, attrs), to: CRUD
  defdelegate delete(id), to: CRUD
end
