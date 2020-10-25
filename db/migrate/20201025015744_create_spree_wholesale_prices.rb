class CreateSpreeWholesalePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_wholesale_prices do |t|
      t.integer "variant_id", null: false
      t.decimal "amount", precision: 10, scale: 2
      t.string "currency"
      t.datetime "deleted_at"
      t.index ["deleted_at"], name: "index_spree_wholesale_prices_on_deleted_at"
      t.index ["variant_id", "currency"], name: "index_wholesale_spree_prices_on_variant_id_and_currency"
      t.index ["variant_id"], name: "index_spree_wholesale_prices_on_variant_id"
      t.timestamps
    end
  end
end
