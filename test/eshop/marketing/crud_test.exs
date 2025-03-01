defmodule Eshop.Marketing.CRUDTest do
  use Eshop.DataCase, async: true

  alias Eshop.Marketing.CRUD
  alias Eshop.Marketing.Schemas.PricingRule

  describe "create_pricing_rule/1" do
    test "should create buy_x_get_y pricing rule" do
      attrs = %{
        name: "test",
        description: "test description",
        strategy: %{
          type: "buy_x_get_y",
          buy_quantity: 2,
          get_quantity: 1
        }
      }

      assert {:ok, %PricingRule{}} = CRUD.create_pricing_rule(attrs)
    end

    test "should create discount_fixed pricing rule" do
      attrs = %{
        name: "test",
        description: "test description",
        strategy: %{
          type: "discount_fixed",
          minimum_quantity: 2,
          discount: Money.new(1_00)
        }
      }

      assert {:ok, %PricingRule{}} = CRUD.create_pricing_rule(attrs)
    end

    test "should create discount_percentage pricing rule" do
      attrs = %{
        name: "test",
        description: "test description",
        strategy: %{
          type: "discount_percentage",
          minimum_quantity: 2,
          discount_percentage: 10
        }
      }

      assert {:ok, %PricingRule{}} = CRUD.create_pricing_rule(attrs)
    end
  end

  describe "fetch_pricing_rule/1" do
    test "should fetch pricing rule by id" do
      %{id: id} = F.insert(:pricing_rule)

      assert {:ok, %PricingRule{id: ^id}} = CRUD.fetch_pricing_rule(id)
    end

    test "should return error when not exist" do
      assert {:error, :not_found} = CRUD.fetch_pricing_rule(1)
    end
  end

  describe "delete_pricing_rule/1" do
    test "should delete pricing rule by id" do
      %{id: id} = F.insert(:pricing_rule)

      assert {:ok, %PricingRule{id: ^id}} = CRUD.delete_pricing_rule(id)
      assert {:error, :not_found} = CRUD.fetch_pricing_rule(id)
    end

    test "should return error when not exist" do
      assert {:error, :not_found} = CRUD.delete_pricing_rule(1)
    end
  end
end
