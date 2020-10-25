FactoryBot.define do
  factory :wholesale_price, class: Spree::WholesalePrice do
    variant
    amount   { BigDecimal('10.00') }
    currency { 'USD' }
  end
end
