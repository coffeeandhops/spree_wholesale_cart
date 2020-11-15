module Spree
  module WholesaleCart
    class RemoveItem
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, variant:, quantity: nil)
        return failure(
          wholesale_order,
          Spree.t('wholesale_cart_is_locked', scope: 'wholesale_cart')) if wholesale_order.locked

        quantity ||= 1

        ActiveRecord::Base.transaction do
          line_item = remove_from_line_item(wholesale_order: wholesale_order, variant: variant, quantity: quantity)

          success(line_item)
        end
      end

      private

      def remove_from_line_item(wholesale_order:, variant:, quantity:)
        line_item = wholesale_order.wholesale_line_items.joins(:variant).where(variant: variant).first

        raise ActiveRecord::RecordNotFound if line_item.nil?
        quantity = line_item.quantity < quantity ? line_item.quantity : quantity

        line_item.quantity -= quantity

        if line_item.quantity.zero?
          wholesale_order.wholesale_line_items.destroy(line_item)
        else
          line_item.save!
        end

        Spree::WholesaleCart::UpdateTotals.new.call(
          wholesale_order: wholesale_order,
          line_item: line_item,
          quantity: quantity,
          items_removed: true
        )

        line_item
      end
    end
  end
end
