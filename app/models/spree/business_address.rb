require 'geocoder'

module Spree
  class BusinessAddress < ::Spree::Address
    geocoded_by :full_address
    after_validation :geocodez, on: [:update, :create]

    has_one :wholesaler
    
    alias_attribute :business_name, :company
    alias_attribute :first_name, :company
    alias_attribute :last_name, :company
    alias_attribute :firstname, :company
    alias_attribute :lastname, :company

    with_options presence: true do
      validates :address1, :city, :country, :company
      validates :zipcode, if: :require_zipcode?
      validates :phone, if: :require_phone?
    end
    
    def full_address
      [address1, address2.presence, city, state_text, country.try(:iso)].compact.join(', ')
    end

    def geocodez
      # Not sure why I need to do the config here
      Geocoder.configure(lookup: :google, api_key: ::Spree::WholesaleCart::Config[:google_map_api_key]) unless ENV["RAILS_ENV"] == "test"
      geocode
    end

  end
end