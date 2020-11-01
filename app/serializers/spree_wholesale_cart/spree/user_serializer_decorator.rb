module SpreeWholesaleCart
  module Spree
    module UserSerializerDecorator
      def self.prepended(base)
        base.attribute :wholesaler, &:wholesaler?

        base.has_one :wholesaler
      end
    end
  end
end

Spree::V2::Storefront::UserSerializer.prepend SpreeWholesaleCart::Spree::UserSerializerDecorator