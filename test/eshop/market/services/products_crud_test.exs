defmodule Eshop.Market.Services.ProductsCRUDTest do
  use Eshop.DataCase, async: true

  alias Eshop.Market.Schemas.Product
  alias Eshop.Market.Services.ProductsCRUD

  describe "create/1" do
    test "creates a product with valid attributes" do
      valid_attrs = %{
        title: "Sample Product",
        description: "A good product",
        price: Money.new(19_99, :GBP),
        image_url: "image_url",
        stock: 1
      }

      assert {:ok, %Product{} = product} = ProductsCRUD.create(valid_attrs)

      assert %{
               title: "Sample Product",
               description: "A good product",
               price: %Money{amount: 19_99, currency: :GBP},
               image_url: "image_url",
               stock: 1
             } = product
    end

    test "returns error with invalid attributes" do
      invalid_attrs = %{description: "Invalid product"}
      assert {:error, %Ecto.Changeset{}} = ProductsCRUD.create(invalid_attrs)
    end
  end

  describe "update/2" do
    setup do
      product_attrs = %{
        title: "Original Product",
        description: "Original description",
        price: Money.new(10_00, :GBP),
        image_url: "original_image.jpg",
        stock: 5
      }

      {:ok, product} = ProductsCRUD.create(product_attrs)

      %{product: product}
    end

    test "updates a product with valid attributes", %{product: product} do
      update_attrs = %{
        title: "Updated Product",
        description: "Updated description",
        price: Money.new(15_00, :GBP),
        image_url: "updated_image.jpg",
        stock: 10
      }

      assert {:ok, %Product{} = updated_product} = ProductsCRUD.update(product, update_attrs)

      assert updated_product.title == "Updated Product"
      assert updated_product.description == "Updated description"
      assert updated_product.price == Money.new(15_00, :GBP)
      assert updated_product.image_url == "updated_image.jpg"
      assert updated_product.stock == 10
    end

    test "updates a product with partial attributes", %{product: product} do
      update_attrs = %{title: "Partially Updated Product"}

      assert {:ok, %Product{} = updated_product} = ProductsCRUD.update(product, update_attrs)

      assert updated_product.title == "Partially Updated Product"
      assert updated_product.description == product.description
      assert updated_product.price == product.price
      assert updated_product.image_url == product.image_url
      assert updated_product.stock == product.stock
    end

    test "returns error when updating with invalid attributes", %{product: product} do
      invalid_attrs = %{title: nil, stock: "invalid"}

      assert {:error, %Ecto.Changeset{}} = ProductsCRUD.update(product, invalid_attrs)

      # Verify the product wasn't changed
      db_product = Repo.get(Product, product.id)
      assert db_product.title == product.title
    end
  end

  describe "delete/1" do
    setup do
      product_attrs = %{
        title: "Product to Delete",
        description: "Will be deleted",
        price: Money.new(5_00, :GBP),
        image_url: "delete_me.jpg",
        stock: 3
      }

      {:ok, product} = ProductsCRUD.create(product_attrs)

      %{product: product}
    end

    test "deletes the given product", %{product: product} do
      assert {:ok, %Product{}} = ProductsCRUD.delete(product.id)
      assert Repo.get(Product, product.id) == nil
    end

    test "returns error when product doesn't exist" do
      assert {:error, _} = ProductsCRUD.delete(1)
    end
  end
end
