defmodule Eshop.Products.Services.CRUDTest do
  use Eshop.DataCase, async: true

  alias Eshop.Products.CRUD
  alias Eshop.Products.Schemas.Product

  describe "create/1" do
    test "creates a product with valid attributes" do
      valid_attrs = %{
        title: "Sample Product",
        description: "A good product",
        code: "SP1",
        price: Money.new(19_99, :GBP),
        image_url: "image_url",
        stock: 1
      }

      assert {:ok, %Product{} = product} = CRUD.create(valid_attrs)

      assert %{
               title: "Sample Product",
               code: "SP1",
               description: "A good product",
               price: %Money{amount: 19_99, currency: :GBP},
               image_url: "image_url",
               stock: 1
             } = product
    end

    test "returns error with invalid attributes" do
      invalid_attrs = %{description: "Invalid product"}
      assert {:error, %Ecto.Changeset{}} = CRUD.create(invalid_attrs)
    end
  end

  describe "update/2" do
    test "updates a product with valid attributes" do
      product = F.insert(:product)

      update_attrs = %{
        title: "Updated Product",
        description: "Updated description",
        code: "UP1",
        price: Money.new(15_00, :GBP),
        image_url: "updated_image.jpg",
        stock: 10
      }

      assert {:ok, %Product{} = updated_product} = CRUD.update(product, update_attrs)

      assert updated_product.title == "Updated Product"
      assert updated_product.description == "Updated description"
      assert updated_product.code == "UP1"
      assert updated_product.price == Money.new(15_00, :GBP)
      assert updated_product.image_url == "updated_image.jpg"
      assert updated_product.stock == 10
    end

    test "updates a product with partial attributes" do
      product = F.insert(:product)

      update_attrs = %{title: "Partially Updated Product"}

      assert {:ok, %Product{} = updated_product} = CRUD.update(product, update_attrs)

      assert updated_product.title == "Partially Updated Product"
      assert updated_product.description == product.description
      assert updated_product.price == product.price
      assert updated_product.image_url == product.image_url
      assert updated_product.stock == product.stock
    end

    test "returns error when updating with invalid attributes" do
      product = F.insert(:product)
      invalid_attrs = %{title: nil, stock: "invalid"}

      assert {:error, %Ecto.Changeset{}} = CRUD.update(product, invalid_attrs)

      # Verify the product wasn't changed
      db_product = Repo.get(Product, product.id)
      assert db_product.title == product.title
    end
  end

  describe "delete/1" do
    test "deletes the given product" do
      product = F.insert(:product)
      assert {:ok, %Product{}} = CRUD.delete(product.id)
      assert Repo.get(Product, product.id) == nil
    end

    test "returns error when product doesn't exist" do
      assert {:error, _} = CRUD.delete(1)
    end
  end
end
