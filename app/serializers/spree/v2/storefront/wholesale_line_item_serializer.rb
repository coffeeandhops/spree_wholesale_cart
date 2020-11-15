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

        belongs_to :variant
      end
    end
  end
end
