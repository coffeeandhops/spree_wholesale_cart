module Spree
  module WholesaleCart
    class AddToOrder
      prepend Spree::ServiceModule::Base

      def call(wholesale_order:, options: {})
        return failure(
          wholesale_order,
          Spree.t('wholesale_cart_is_locked', scope: 'wholesale_cart')) if wholesale_order.locked

        ApplicationRecord.transaction do
          run :add_line_items_to_order
          run ::Spree::WholesaleCart::OrderRecalculate
        end
      end

      private
      attr_accessor :allow_under_min_checkout

      def add_line_items_to_order(wholesale_order:, options: {})
        pp "************************************"
        pp "************************************"
        pp "************************************"
        pp wholesale_order.is_wholesale?
        pp wholesale_order.user
        pp "************************************"
        pp "************************************"
        pp "************************************"
        return failure(wholesale_order) unless wholesale_order.is_wholesale? || allow_under_min_checkout

        options ||= {}
        order = wholesale_order.order
        order.line_items.destroy
        line_items = []
        wholesale_order.wholesale_line_items.each do |wholesale_line_item|

          opts = ::Spree::PermittedAttributes.line_item_attributes.flatten.each_with_object({}) do |attribute, result|
            result[attribute] = options[attribute]
          end.merge(currency: order.currency).delete_if { |_key, value| value.nil? }

          price = wholesale_order.is_wholesale? ? wholesale_line_item.wholesale_price : wholesale_line_item.retail_price

          line_item = order.line_items.new(quantity: wholesale_line_item.quantity,
                                            variant: wholesale_line_item.variant,
                                            price: price,
                                            options: opts)
  
          line_item.target_shipment = options[:shipment] if options.key? :shipment
  
          return failure(line_item) unless line_item.save
          line_items << line_item
          
        end
        
        ::Spree::TaxRate.adjust(order, line_items) if line_items.count > 0
        return failure(wholesale_order) unless wholesale_order.update_columns(locked: true)
        success(order: order, options: options)
      end

      def allow_under_min_checkout
        @allow_under_min_checkout ||= ::Spree::WholesaleCart::Config[:allow_under_minimum_checkout]
      end
    end
  end
end
