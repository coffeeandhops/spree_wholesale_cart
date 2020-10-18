module SpreeWholesaleOrder
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.has_one :wholesale_order, class_name: "Spree::WholesaleOrder"
      end
    end
  end
end

::Spree::Order.prepend SpreeWholesaleOrder::Spree::OrderDecorator
