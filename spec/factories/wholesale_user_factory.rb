FactoryBot.define do
  
  factory :wholesale_user, :parent => :user do
    spree_roles { [Spree::Role.find_or_create_by(name: "wholesaler")] }
  end

  factory :wholesale_user_with_addresses, :parent => :user_with_addresses do
    after(:create) do |user, evaluator|
      wholesaler = user.create_wholesaler(main_contact: "Wile E Coyote")
      wholesaler.business_address = create(:business_address)
      user.save
      user.reload
    end

  end
end
