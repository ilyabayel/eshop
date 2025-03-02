defmodule Eshop.Repo.Migrations.InitShopTables do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:products) do
      add :title, :string, null: false
      add :description, :text
      add :code, :string, null: false
      add :image_url, :string
      add :price, :money_with_currency
      add :stock, :integer, default: 0

      timestamps(type: :utc_datetime_usec)
    end

    create_if_not_exists table(:carts) do
      add :session_key, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create_if_not_exists table(:cart_items) do
      add :cart_id, references(:carts), null: false
      add :product_id, references(:products), null: false
      add :quantity, :integer, default: 1, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create_if_not_exists unique_index(:cart_items, [:cart_id, :product_id])

    create_if_not_exists table(:pricing_rules) do
      add :name, :string, null: false
      add :description, :text
      add :strategy, :map, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create_if_not_exists table(:pricing_rules_products) do
      add :pricing_rule_id, references(:pricing_rules), null: false
      add :product_id, references(:products), null: false

      timestamps(type: :utc_datetime_usec)
    end

    # Create unique index to prevent duplicate pricing_rule-product combinations
    create_if_not_exists unique_index(:pricing_rules_products, [:pricing_rule_id, :product_id])
  end

  def down do
    # Not to lose any data do not drop any tables automatically
    # Drop tables manually if needed
  end
end
