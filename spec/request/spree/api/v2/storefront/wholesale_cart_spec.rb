require 'spec_helper'

describe 'API V2 Storefront Wholesale Cart Spec', type: :request do
  let(:wholesale_order) { create(:wholesale_order) }
  let(:order) { wholesale_order.order }
  let(:wholesaler_user) { wholesale_order.user }
  let(:wholesale_token) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_order.user.id, expires_in: nil) }
  let(:wholesale_headers_bearer) { { 'Authorization' => "Bearer #{wholesale_token.token}" } }
  let(:wholesale_headers_order_token) { { 'X-Spree-Order-Token' => wholesale_order.token } }
  let(:headers) { { 'X-Spree-Order-Token' => wholesale_order.token, 'Authorization' => "Bearer #{wholesale_token.token}" } }

  describe 'wholesale_Cart#show' do
    context 'as wholesaler' do
      before { get "/api/v2/storefront/wholesale_cart", headers: headers }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns a valid JSON response' do
        expect(json_response['data']).to have_id(wholesale_order.id.to_s)

        expect(json_response['data']).to have_type('wholesale_order')
        expect(json_response['data']).to have_relationships(:order, :user)

        expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(wholesale_order.wholesale_item_total)
        expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(wholesale_order.display_wholesale_item_total)
        expect(json_response['data']).to have_attribute(:display_retail_item_total).with_value(wholesale_order.display_retail_item_total)
        pp json_response
      end

      # context 'with params "include=user"' do
      #   before { get "/api/v2/storefront/wholesalers/#{wholesaler.id}?include=user", headers: headers }
  
      #   it 'returns wholesale_cart data with included user' do
      #     expect(json_response['included']).to    include(have_type('user'))
      #   end
      # end

    end
  end

end