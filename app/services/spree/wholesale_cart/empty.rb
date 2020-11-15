module Spree
  module WholesaleCart
    class Empty
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, options: nil)
        options ||= {}

        return failure(
          wholesale_order,
          Spree.t('wholesale_cart_is_locked', scope: 'wholesale_cart')) if wholesale_order.locked

        ActiveRecord::Base.transaction do
 
          wholesale_order.wholesale_line_items.destroy_all

          wholesale_order.retail_item_total = 0.0
          wholesale_order.wholesale_item_total = 0.0
          wholesale_order.item_count = 0
          wholesale_order.save
        end
        success(wholesale_order)
      end
    end
  end
end
