class RenameWholesaleTotalToWholesaleItemTotal < SpreeExtension::Migration[6.0]
  def change
    rename_column :spree_wholesale_orders, :wholesale_total, :wholesale_item_total
  end
end
