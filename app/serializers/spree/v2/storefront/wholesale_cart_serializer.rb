module Spree
  module V2
    module Storefront
      class WholesaleCartSerializer < BaseSerializer
        set_type :wholesale_order

        attributes :wholesale_item_total, :retail_item_total, :order_id

        attribute :display_wholesale_item_total, &:display_wholesale_item_total
        attribute :display_retail_item_total, &:display_retail_item_total
      end
    end
  end
end
