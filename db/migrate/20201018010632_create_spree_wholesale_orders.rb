class CreateSpreeWholesaleOrders < SpreeExtension::Migration[6.0]
  def change
    create_table :spree_wholesale_orders do |t|
      t.integer :order_id
      t.decimal "retail_item_total", precision: 10, scale: 2, default: "0.0", null: false
      t.decimal "wholesale_total", precision: 10, scale: 2, default: "0.0", null: false
      t.integer "item_count", default: 0

      t.boolean "locked", default: false
     
      t.timestamps
    end
  end
end
