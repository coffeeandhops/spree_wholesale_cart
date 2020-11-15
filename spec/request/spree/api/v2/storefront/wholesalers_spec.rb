require 'spec_helper'

describe 'API V2 Storefront Wholesalers Spec', type: :request do
  let(:wholesaler) { create(:wholesaler) }

  describe 'wholesalers#show' do
    context 'with existing wholesaler' do
      before { get "/api/v2/storefront/wholesalers/#{wholesaler.id}" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns a valid JSON response' do
        expect(json_response['data']).to have_id(wholesaler.id.to_s)

        expect(json_response['data']).to have_type('wholesaler')
        expect(json_response['data']).to have_relationships(:business_address, :user)

        expect(json_response['data']).to have_attribute(:main_contact).with_value(wholesaler.main_contact)
        expect(json_response['data']).to have_attribute(:alternate_contact).with_value(wholesaler.alternate_contact)
        expect(json_response['data']).to have_attribute(:web_address).with_value(wholesaler.web_address)
        expect(json_response['data']).to have_attribute(:alternate_email).with_value(wholesaler.alternate_email)
        expect(json_response['data']).to have_attribute(:notes).with_value(wholesaler.notes)
        expect(json_response['data']).to have_attribute(:user_id).with_value(wholesaler.user_id)
      end

      context 'with params "include=business_address"' do
        before { get "/api/v2/storefront/wholesalers/#{wholesaler.id}?include=business_address" }
  
        it 'returns wholesaler data with included business_address' do
          expect(json_response['included']).to    include(have_type('business_address'))
        end
      end

    end
  end

end