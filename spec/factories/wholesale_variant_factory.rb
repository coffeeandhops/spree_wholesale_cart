FactoryBot.define do
  factory :wholesale_variant, parent: :master_variant do
    wholesale_price
  end
end
