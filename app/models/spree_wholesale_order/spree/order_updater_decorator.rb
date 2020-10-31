module SpreeWholesaleOrder
  module Spree
    module OrderUpdaterDecorator
      # def update
      #   update_line_items
      #   super
      # end

      def update_item_total
        return super unless order.is_wholesale?
        order.item_total = order.wholesale_item_total
        update_order_total
      end

      # def update_line_items
      #   # order.line_items.reload
      #   if order.is_wholesale?
      #     should_update_items = line_items.should_update_to_wholesale

      #     should_update_items.each do |item|
      #       should_update = item.price != item.variant.wholesale_price
      #       if should_update
      #         item.update_price
      #         item.save!
      #         item.redo_adjustments
      #       end
      #     end
      #   else
      #     wholesale_items = line_items.should_update_to_non_wholesale
      #     wholesale_items.each do |item|
      #       should_update = item.price != item.variant.price
      #       if should_update
      #         begin
      #           item.update_price
      #           item.save!
      #           item.redo_adjustments
      #         rescue => exception
                
      #         end
      #       end
      #     end
      #   end
      #  end
    end
  end
end

Spree::OrderUpdater.prepend SpreeWholesaleOrder::Spree::OrderUpdaterDecorator
