defmodule Eshop.CartAndCheckout.CRUDTest do
  use Eshop.DataCase, async: true

  alias Eshop.CartAndCheckout.CRUD

  describe "fetch_cart/1" do
    test "returns the cart when it exists" do
      cart = F.insert(:cart)

      assert {:ok, ^cart} = CRUD.fetch_cart(cart.id)
    end

    test "returns error when cart does not exist" do
      result = CRUD.fetch_cart(999)
      assert {:error, "Cart not found"} = result
    end
  end

  describe "create_cart/1" do
    test "creates a cart with valid attributes" do
      assert {:ok, %{session_key: "12345"}} = CRUD.create_cart(%{session_key: "12345"})
    end

    test "returns error with invalid attributes" do
      assert {:error, changeset} = CRUD.create_cart(%{})
      assert %{session_key: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "create_cart_item/1" do
    test "creates a cart item with valid attributes" do
      %{id: cart_id} = F.insert(:cart)
      %{id: product_id} = F.insert(:product)

      attrs = %{
        cart_id: cart_id,
        product_id: product_id,
        quantity: 2
      }

      assert {:ok, %{quantity: 2, cart_id: ^cart_id, product_id: ^product_id}} = CRUD.create_cart_item(attrs)
    end

    test "returns error with invalid attributes" do
      result = CRUD.create_cart_item(%{})
      assert {:error, changeset} = result

      assert %{cart_id: ["can't be blank"], product_id: ["can't be blank"], quantity: ["can't be blank"]} ==
               errors_on(changeset)
    end
  end

  describe "fetch_cart_item_by/2" do
    test "returns the cart item when it exists" do
      cart = F.insert(:cart)
      product = F.insert(:product)
      cart_item = F.insert(:cart_item, cart: cart, product: product, quantity: 3)

      assert {:ok, fetched_item} = CRUD.fetch_cart_item_by(cart.id, product.id)
      assert fetched_item.id == cart_item.id
      assert fetched_item.quantity == 3
    end

    test "returns error when cart item does not exist" do
      cart = F.insert(:cart)
      product = F.insert(:product)

      result = CRUD.fetch_cart_item_by(cart.id, product.id)
      assert {:error, :not_found} = result
    end
  end

  describe "fetch_cart_by_session_key/1" do
    test "returns the cart when it exists with the given session key" do
      cart = F.insert(:cart, session_key: "unique_session_123")

      assert {:ok, fetched_cart} = CRUD.fetch_cart_by_session_key("unique_session_123")
      assert fetched_cart.id == cart.id
      assert fetched_cart.session_key == "unique_session_123"
    end

    test "returns error when cart with session key does not exist" do
      result = CRUD.fetch_cart_by_session_key("nonexistent_key")
      assert {:error, :not_found} = result
    end
  end

  describe "update_cart_item/2" do
    test "updates a cart item with valid attributes" do
      cart_item = F.insert(:cart_item, quantity: 2)

      attrs = %{quantity: 5}

      assert {:ok, updated_item} = CRUD.update_cart_item(cart_item, attrs)
      assert updated_item.id == cart_item.id
      assert updated_item.quantity == 5
    end

    test "returns error with invalid attributes" do
      cart_item = F.insert(:cart_item, quantity: 2)

      assert {:error, changeset} = CRUD.update_cart_item(cart_item, %{quantity: 0})
      assert %{quantity: ["must be greater than 0"]} = errors_on(changeset)
    end
  end

  describe "delete_cart_item/1" do
    test "deletes the given cart item" do
      cart_item = F.insert(:cart_item)

      assert {:ok, _deleted} = CRUD.delete_cart_item(cart_item)
      assert {:error, :not_found} = Repo.fetch(Eshop.CartAndCheckout.Schemas.CartItem, cart_item.id)
    end
  end
end
