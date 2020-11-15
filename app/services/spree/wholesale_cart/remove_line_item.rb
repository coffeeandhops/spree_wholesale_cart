module Spree
  module WholesaleCart
    class RemoveLineItem
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, line_item:, options: nil)
        return failure(
          wholesale_order,
          Spree.t('wholesale_cart_is_locked', scope: 'wholesale_cart')) if wholesale_order.locked

        options ||= {}
        ActiveRecord::Base.transaction do
 
          line_item.destroy!
          Spree::WholesaleCart::UpdateTotals.new.call(
            wholesale_order: wholesale_order,
            line_item: line_item,
            items_removed: true
          )
        end
        success(line_item)
      end
    end
  end
end
