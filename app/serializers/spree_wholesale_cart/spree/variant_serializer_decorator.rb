module SpreeWholesaleCart
  module Spree
    module VariantSerializerDecorator
      def self.prepended(base)
        base.attributes :wholesale_price, :display_wholesale_price

      end
    end
  end
end

Spree::V2::Storefront::VariantSerializer.prepend SpreeWholesaleCart::Spree::VariantSerializerDecorator