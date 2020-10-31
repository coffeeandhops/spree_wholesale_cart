module Spree
  module WholesaleCart
    class UpdateTotals
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, line_item:, quantity: nil, items_removed: false, options: nil)
        options ||= {}
        quantity ||= line_item.quantity
        ActiveRecord::Base.transaction do
          retail_price_adjustment = line_item.retail_price * quantity
          wholesale_price_adjustment = line_item.wholesale_price * quantity

          sign = items_removed ? -1 : 1

          wholesale_order.retail_item_total += (retail_price_adjustment * sign)
          wholesale_order.wholesale_item_total += (wholesale_price_adjustment * sign)
          wholesale_order.save
        end
        success(wholesale_order)
      end
    end
  end
end
