class AddUserIdToSpreeWholesaleOrders < SpreeExtension::Migration[6.0]
  def change
    add_column :spree_wholesale_orders, :user_id, :integer
    add_index :spree_wholesale_orders, :user_id, name: "index_spree_wholesale_orders_on_user_id"
  end
end
