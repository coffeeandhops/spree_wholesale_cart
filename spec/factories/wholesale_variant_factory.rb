FactoryBot.define do
  factory :wholesale_variant, parent: :master_variant do
    price { 20.0 }
    wholesale_price
  end
end
