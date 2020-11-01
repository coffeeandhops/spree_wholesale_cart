FactoryBot.define do
  factory :business_address, class: Spree::BusinessAddress do
    company           { 'ACME Consulting' }
    address1          { '10 Lovely Street' }
    address2          { 'Northwest' }
    city              { 'Herndon' }
    zipcode           { '35005' }
    phone             { '555-555-0199' }
    alternative_phone { '555-555-0199' }

    state { |address| address.association(:state) || Spree::State.last }

    country do |address|
      if address.state
        address.state.country
      else
        address.association(:country)
      end
    end
    after(:build) { |business_address| GeocoderStub.stub_with(business_address) }
  end
end
