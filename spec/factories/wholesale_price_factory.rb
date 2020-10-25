FactoryBot.define do
  factory :wholesale_price, class: Spree::WholesalePrice do
    variant
    amount   { 19.99 }
    currency { 'USD' }
  end
end
