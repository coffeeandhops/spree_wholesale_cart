FactoryBot.define do
  factory :wholesale_line_item, class: Spree::WholesaleLineItem do
    transient do
      association :product
      item_quantity { 1 }
      wholesale_variant { create(:wholesale_variant) }
    end
    wholesale_order
    quantity { item_quantity }
    retail_price    { BigDecimal('20.00') }
    wholesale_price    { BigDecimal('10.00') }
    currency { wholesale_order.currency }
    variant { wholesale_variant }
  end
end
