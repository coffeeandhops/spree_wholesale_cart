  module Spree
    module WholesaleLineItemSerializerDecorator
      def self.prepended(base)
        base.attribute :total_wholesale_price, &:total_wholesale_price
        base.attribute :display_wholesale_price, &:display_wholesale_price
        base.attribute :is_wholesaleable, &:is_wholesaleable?
        base.attribute :display_total_wholesale_price, &:display_total_wholesale_price
      end
    end
  end

Spree::V2::Storefront::LineItemSerializer.prepend SpreeWholesaleCart::Spree::LineItemSerializerDecorator
module Spree
  module V2
    module Storefront
      class WholesaleLineItemSerializer < BaseSerializer
        set_type :wholesale_line_item

        attributes :wholesale_price, :retail_price

        attribute :total_wholesale_price, &:total_wholesale_price
        attribute :total_retail_price, &:total_retail_price
        attribute :display_wholesale_price, &:display_wholesale_price
        attribute :display_retail_price, &:display_retail_price
        attribute :display_total_wholesale_price, &:display_total_wholesale_price
        attribute :display_total_retail_price, &:display_total_retail_price
      end
    end
  end
end
