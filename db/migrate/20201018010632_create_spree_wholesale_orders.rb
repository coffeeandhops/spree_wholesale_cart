class CreateSpreeWholesaleOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_wholesale_orders do |t|
      t.integer :order_id
      t.timestamps
    end
  end
end
