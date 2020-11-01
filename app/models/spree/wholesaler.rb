module Spree
  class Wholesaler < Spree::Base
    belongs_to :user, class_name: Spree.user_class.to_s
    belongs_to :business_address, dependent: :destroy, class_name: "Spree::BusinessAddress"
    validates :main_contact, presence: true

    accepts_nested_attributes_for :business_address
    
    delegate :email, to: :user
    delegate :company, :phone, to: :find_or_build_business_address

    def find_or_build_business_address
      business_address ||= build_business_address(country: Spree::Country.new)
    end
  end
end

