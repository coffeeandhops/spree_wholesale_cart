module Spree
  module V2
    module Storefront
      class WholesalerSerializer < BaseSerializer
        set_type :wholesaler

        attributes :main_contact, :alternate_contact, :web_address,
          :alternate_email, :notes, :user_id
    
        belongs_to :user
        belongs_to :business_address
      end
    end
  end
end
