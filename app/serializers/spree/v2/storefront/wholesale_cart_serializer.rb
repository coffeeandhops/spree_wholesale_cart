module Spree
  module V2
    module Storefront
      class WholesaleCartSerializer < BaseSerializer
        set_type :wholesale_order

        attributes :wholesale_item_total, :retail_item_total, :order_id, :item_count

        attribute :display_wholesale_item_total, &:display_wholesale_item_total
        attribute :display_retail_item_total, &:display_retail_item_total

        has_many :wholesale_line_items
        has_many :variants

      end
    end
  end
end
