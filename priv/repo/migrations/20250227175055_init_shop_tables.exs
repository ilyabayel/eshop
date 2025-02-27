defmodule Eshop.Repo.Migrations.InitShopTables do
  use Ecto.Migration

  def up do
    create table(:products) do
      add :title, :string, null: false
      add :description, :text
      add :image_url, :string
      add :price_amount, :integer
      add :price_currency, :string
      add :stock, :integer, default: 0

      timestamps(type: :utc_datetime_usec)
    end

    create table(:carts) do
      add :total_price, :decimal, precision: 10, scale: 2
      add :subtotal_price, :decimal, precision: 10, scale: 2
      add :user_id, references(:users), null: true

      timestamps(type: :utc_datetime_usec)
    end

    create table(:carts_products) do
      add :cart_id, references(:carts), null: false
      add :product_id, references(:products), null: false
      add :quantity, :integer, default: 1, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:carts_products, [:cart_id, :product_id])

    create table(:pricing_rules) do
      add :name, :string, null: false
      add :description, :text
      add :strategy, :string, null: false
      add :strategy_variables, :map, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create table(:pricing_rules_products) do
      add :pricing_rule_id, references(:pricing_rules), null: false
      add :product_id, references(:products), null: false

      timestamps(type: :utc_datetime_usec)
    end

    # Create unique index to prevent duplicate pricing_rule-product combinations
    create unique_index(:pricing_rules_products, [:pricing_rule_id, :product_id])
  end

  def down do
    # Not to lose any data do not drop any tables automatically
    # Drop tables manually if needed
  end
end
