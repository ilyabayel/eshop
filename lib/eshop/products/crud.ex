defmodule Eshop.Products.CRUD do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Eshop.Products.Schemas.Product
  alias Eshop.Repo

  def create_product(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def fetch_product(id) do
    case Repo.fetch(Product, id) do
      {:ok, product} -> {:ok, product}
      {:error, :not_found} -> {:error, "Product not found"}
    end
  end

  def list_products do
    Repo.all(from(p in Product, preload: :pricing_rules))
  end

  def update_product(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(id) do
    case Repo.fetch(Product, id) do
      {:ok, product} -> Repo.delete(product)
      {:error, :not_found} -> {:error, "Product not found"}
    end
  end
end
