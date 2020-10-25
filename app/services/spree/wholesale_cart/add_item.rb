module Spree
  module WholesaleCart
    class AddItem
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, variant:, quantity: nil)
        ApplicationRecord.transaction do
          run :add_to_line_item
          # run Spree::Dependencies.cart_recalculate_service.constantize
        end
      end

      private

      def add_to_line_item(wholesale_order:, variant:, quantity: nil)
        quantity ||= 1

        line_item = wholesale_order.wholesale_line_items.joins(:variant).where(variant: variant).first

        line_item_created = line_item.nil?
        if line_item.nil?
          line_item = wholesale_order.wholesale_line_items.new(
            quantity: quantity,
            wholesale_price: variant.wholesale_price,
            retail_price: variant.price,
            variant: variant,
            currency: wholesale_order.currency)
        else
          line_item.quantity += quantity.to_i
        end

        return failure(line_item) unless line_item.save

        wholesale_order.retail_item_total += (line_item.retail_price * line_item.quantity)
        wholesale_order.wholesale_item_total += (line_item.wholesale_price * line_item.quantity)
        wholesale_order.save

        # wholesale_order.update_totals
        # wholesale_order.save
        # line_item.reload.update_price

        # ::Spree::TaxRate.adjust(wholesale_order, [line_item]) if line_item_created
        success(wholesale_order: wholesale_order, wholesale_line_item: line_item, line_item_created: line_item_created)
      end
    end
  end
end
