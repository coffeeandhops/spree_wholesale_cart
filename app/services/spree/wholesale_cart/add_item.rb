module Spree
  module WholesaleCart
    class AddItem
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, variant:, quantity: nil)
        ApplicationRecord.transaction do
          run :add_to_line_item
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

        Spree::WholesaleCart::UpdateTotals.new.call(wholesale_order: wholesale_order, line_item: line_item)

        # ::Spree::TaxRate.adjust(wholesale_order, [line_item]) if line_item_created
        success(wholesale_order: wholesale_order, wholesale_line_item: line_item, line_item_created: line_item_created)
      end
    end
  end
end
