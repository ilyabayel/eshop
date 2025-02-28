defmodule Eshop.Products.CRUD do
  @moduledoc false

  alias Eshop.Products.Schemas.Product
  alias Eshop.Repo

  def create(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete(id) do
    case Repo.fetch(Product, id) do
      {:ok, product} -> Repo.delete(product)
      {:error, :not_found} -> {:error, :not_found}
    end
  end
end
