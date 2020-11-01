FactoryBot.define do
  factory :wholesaler, class: Spree::Wholesaler do
    user { create(:wholesale_user) }
    main_contact { "Mr Contacter" }
    alternate_contact { "Mr Manager" }
    web_address { "testcompany.com" }
    alternate_email { "alternate@testcompany.com" }
    notes { "Some sort of note" }
    business_address { create(:business_address) }
  end
end
