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
end
