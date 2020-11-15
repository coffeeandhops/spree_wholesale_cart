module Spree
  module WholesaleCart
    class SetQuantity
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, line_item:, quantity: nil)
        return failure(
          wholesale_order,
          Spree.t('wholesale_cart_is_locked', scope: 'wholesale_cart')) if wholesale_order.locked

        ActiveRecord::Base.transaction do
          run :change_item_quantity
        end
      end

      private

      def change_item_quantity(wholesale_order:, line_item:, quantity:)
        items_removed = quantity <= line_item.quantity
        updated_quantity = (line_item.quantity - quantity).abs

        return failure(line_item) unless line_item.update(quantity: quantity)

        Spree::WholesaleCart::UpdateTotals.new.call(
          wholesale_order: wholesale_order,
          line_item: line_item,
          quantity: updated_quantity,
          items_removed: items_removed
        )

        success(wholesale_order: wholesale_order, line_item: line_item)
      end
    end
  end
end
