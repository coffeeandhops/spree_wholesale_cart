module SpreeWholesaleCart
  module Spree
    module ProductSerializerDecorator
      def self.prepended(base)
        base.attributes :wholesale_price, :display_wholesale_price

      end
    end
  end
end

Spree::V2::Storefront::ProductSerializer.prepend SpreeWholesaleCart::Spree::ProductSerializerDecorator