FactoryBot.define do
  factory :wholesale_line_item, class: Spree::WholesaleLineItem do
    transient do
      association :product
      item_quantity { 1 }
    end
    wholesale_order
    quantity { item_quantity }
    retail_price    { BigDecimal('20.00') }
    wholesale_price    { BigDecimal('10.00') }
    currency { wholesale_order.currency }
    variant { product.master }
  end
end
