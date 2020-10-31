module SpreeWholesaleOrder
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.has_one :wholesale_order, class_name: "Spree::WholesaleOrder"
        base.delegate :is_wholesale?, :wholesale_item_total, to: :wholesale_order
      end
    end
  end
end

::Spree::Order.prepend SpreeWholesaleOrder::Spree::OrderDecorator
