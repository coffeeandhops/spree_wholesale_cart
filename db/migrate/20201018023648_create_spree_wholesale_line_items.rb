class CreateSpreeWholesaleLineItems < SpreeExtension::Migration[6.0]
  def change
    create_table :spree_wholesale_line_items do |t|
      t.integer :wholesale_order_id
      t.integer :variant_id
      t.integer :quantity
      t.decimal "price", precision: 10, scale: 2, null: false
      t.string "currency"

      t.timestamps

      t.index ["order_id"], name: "index_wholesale_spree_line_items_on_order_id"
      t.index ["variant_id"], name: "index_spree_wholesale_line_items_on_variant_id"
    end
  end
end
