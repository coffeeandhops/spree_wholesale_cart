module SpreeWholesaleOrder
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.has_many :wholesale_line_items, class_name: "Spree::WholesaleLineItem"
      end
    end
  end
end

::Spree::Order.prepend SpreeWholesaleOrder::Spree::VariantDecorator
