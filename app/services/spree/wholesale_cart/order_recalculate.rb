module Spree
  module WholesaleCart
    class OrderRecalculate
      prepend Spree::ServiceModule::Base

      def call(order:, options: {})
        order_updater = ::Spree::OrderUpdater.new(order)
        
        order.payments.store_credits.checkout.destroy_all
        order_updater.update
        
        line_items = order.line_items

        shipment = options[:shipment]
        if shipment.present?
          # ADMIN END SHIPMENT RATE FIX
          # refresh shipments to ensure correct shipment amount is calculated when using price sack calculator
          # for calculating shipment rates.
          # Currently shipment rate is calculated on previous order total instead of current order total when updating a shipment from admin end.
          order.refresh_shipment_rates(::Spree::ShippingMethod::DISPLAY_ON_BACK_END)
          shipment.update_amounts
        else
          order.ensure_updated_shipments
        end
        # ::Spree::TaxRate.adjust(order, line_items)

        # line_items.each do |line_item|
        #   ::Spree::Adjustable::AdjustmentsUpdater.update(line_item)
        #   line_item.reload
        #   ::Spree::TaxRate.adjust(order, [line_item])
        # end

        order_updater.update
        success(order)
      end
    end
  end
end
