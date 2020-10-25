class AddWholesalePriceToWholesaleLineItems < SpreeExtension::Migration[6.0]
  def change
    rename_column :spree_wholesale_line_items, :price, :wholesale_price
    add_column :spree_wholesale_line_items, :retail_price, :decimal, precision: 10, scale: 2, null: false
  end
end
