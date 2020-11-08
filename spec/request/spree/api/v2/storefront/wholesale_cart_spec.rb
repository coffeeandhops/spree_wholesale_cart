require 'spec_helper'

describe 'API V2 Storefront Wholesale Cart Spec', type: :request do
  let(:default_currency) { 'USD' }
  let(:store) { create(:store, default_currency: default_currency) }
  let(:currency) { store.default_currency }
  let(:user)  { create(:user) }
  # let(:order) { create(:order, user: user, currency: default_currency) }
  let(:order) { create(:order, user: user, store: store, currency: currency) }

  let(:wholesale_order) { create(:wholesale_order, order: order) }
  let(:wholesale_token) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_order.user.id, expires_in: nil) }
  let(:wholesale_headers_bearer) { { 'Authorization' => "Bearer #{wholesale_token.token}" } }
  let(:wholesale_headers_order_token) { { 'X-Spree-Order-Token' => wholesale_order.token } }
  let(:headers) { { 'X-Spree-Order-Token' => wholesale_order.token, 'Authorization' => "Bearer #{wholesale_token.token}" } }

  describe 'wholesale_Cart#show' do
    before do
      allow_any_instance_of(Spree::Api::V2::Storefront::WholesaleCartController).to receive(:spree_current_order).and_return(order)
    end

    context 'as wholesaler' do
      before { get "/api/v2/storefront/wholesale_cart", headers: headers }
      # it_behaves_like 'returns 200 HTTP status'

      it 'returns a valid JSON response' do
        expect(json_response['data']).to have_id(wholesale_order.id.to_s)
        expect(json_response['data']).to have_type('wholesale_order')
        expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(wholesale_order.wholesale_item_total.to_s)
        expect(json_response['data']).to have_attribute(:retail_item_total).with_value(wholesale_order.retail_item_total.to_s)
        expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(wholesale_order.display_wholesale_item_total.to_s)
        expect(json_response['data']).to have_attribute(:display_retail_item_total).with_value(wholesale_order.display_retail_item_total.to_s)
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