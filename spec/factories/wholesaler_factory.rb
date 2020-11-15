FactoryBot.define do
  factory :wholesaler, class: Spree::Wholesaler do
    transient do
      wholesale_user { create(:wholesale_user) }
    end
    user { wholesale_user }
    main_contact { "Mr Contacter" }
    alternate_contact { "Mr Manager" }
    web_address { "testcompany.com" }
    alternate_email { "alternate@testcompany.com" }
    notes { "Some sort of note" }
    business_address { create(:business_address) }

    after(:create) do |wholesaler, evaluator|
      wholesaler_role = Spree::Role.find_or_create_by(name: "wholesaler")
      wholesaler.user.spree_roles << wholesaler_role unless wholesaler.user.spree_roles.include?(wholesaler_role)
    end
  end
end
