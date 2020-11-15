require 'spec_helper'

describe 'API V2 Storefront Wholesale Cart Spec', type: :request do
  let(:default_currency) { 'USD' }
  let(:store) { create(:store, default_currency: default_currency) }
  let(:currency) { store.default_currency }
  let(:user)  { create(:user) }
  # let(:order) { create(:order, user: user, currency: default_currency) }
  let(:order) { create(:order, user: user, store: store, currency: currency) }
  let(:variant) { create(:variant) }

  let(:wholesale_order) { create(:wholesale_order, order: order) }
  let(:wholesale_token) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_order.user.id, expires_in: nil) }
  let(:wholesale_headers_bearer) { { 'Authorization' => "Bearer #{wholesale_token.token}" } }
  let(:wholesale_headers_order_token) { { 'X-Spree-Order-Token' => wholesale_order.token } }
  let(:headers) { { 'X-Spree-Order-Token' => wholesale_order.token, 'Authorization' => "Bearer #{wholesale_token.token}" } }
  # let!(:wholesale_line_item) { create(:wholessale_line_item, wholesale_order: wholesale_order) }


  shared_examples 'returns valid wholesale_cart JSON' do
    it 'returns a valid wholesale_cart JSON response' do
      wholesale_order.reload
      expect(json_response['data']).to be_present
      expect(json_response['data']).to have_id(wholesale_order.id.to_s)
      expect(json_response['data']).to have_type('wholesale_order')
      expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(wholesale_order.wholesale_item_total.to_s)
      expect(json_response['data']).to have_attribute(:retail_item_total).with_value(wholesale_order.retail_item_total.to_s)
      expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(wholesale_order.display_wholesale_item_total.to_s)
      expect(json_response['data']).to have_attribute(:display_retail_item_total).with_value(wholesale_order.display_retail_item_total.to_s)
      expect(json_response['data']).to have_attribute(:item_count).with_value(wholesale_order.item_count)
    end
  end

  shared_examples 'wholesale order' do
    context "success" do
      before { execute }
      it_behaves_like 'returns 200 HTTP status'
      it_behaves_like 'returns valid wholesale_cart JSON'
    end

    context 'locked wholesale order' do
      before do
        wholesale_order.update_columns(locked: true)
        execute
      end

      it_behaves_like 'returns 422 HTTP status'
    end
  end

  shared_examples 'no current wholesale order' do
    context "order doesn't exist" do
      before do
        wholesale_order.destroy
        execute
      end
  
      it_behaves_like 'returns 404 HTTP status'
    end
 
  end

  shared_context 'creates guest wholesale_order with guest token' do
    let(:guest_token) { 'guest_token' }
    let!(:order)      { create(:order, token: guest_token, store: store, currency: currency) }
    let(:order_token) { { 'X-Spree-Order-Token' => order.token } }
    let!(:headers)    { order_token }
  end

  describe 'wholesale_Cart#show' do
    before do
      allow_any_instance_of(Spree::Api::V2::Storefront::WholesaleCartController).to receive(:spree_current_order).and_return(order)
    end

    context 'as wholesaler' do
      before { get "/api/v2/storefront/wholesale_cart", headers: headers }

      it_behaves_like 'returns 200 HTTP status'
      it_behaves_like 'returns valid wholesale_cart JSON'

      context 'with params "include=wholesale_line_items,variants"' do
        before { get "/api/v2/storefront/wholesale_cart?include=wholesale_line_items,variants", headers: headers }
  
        it 'returns wholesale_cart data with included wholesale_line_items' do
          expect(json_response['included']).to    include(have_type('wholesale_line_item'))
          expect(json_response['included']).to    include(have_type('variant'))
        end
      end

    end
  end


  describe 'wholesale_Cart#add_item' do
    let(:options) { {} }
    let(:params) { { variant_id: variant.id, quantity: 5, options: options, include: 'variants' } }
    let(:execute) { post '/api/v2/storefront/wholesale_cart/add_item', params: params, headers: headers }

    before do
      allow_any_instance_of(Spree::Api::V2::Storefront::WholesaleCartController).to receive(:spree_current_order).and_return(order)
    end

    it_behaves_like 'wholesale order'

    shared_examples 'adds item' do
      before { execute }

      it 'with success' do
        expect(wholesale_order.wholesale_line_items.count).to eq(16)
        expect(wholesale_order.wholesale_line_items.last.variant).to eq(variant)
        expect(wholesale_order.wholesale_line_items.last.quantity).to eq(5)
        expect(json_response['included']).to include(have_type('variant').and(have_id(variant.id.to_s)))
      end

    end

    shared_examples 'doesnt add item with quantity unnavailable' do
      before do
        variant.stock_items.first.update(backorderable: false)
        params[:quantity] = 11
        execute
      end

      it_behaves_like 'returns 422 HTTP status'

      it 'returns an error' do
        expect(json_response[:error]).to eq("Quantity selected of \"#{variant.name} (#{variant.options_text})\" is not available.")
      end
    end

    context 'as wholesaler' do
      it_behaves_like 'adds item'
      it_behaves_like 'doesnt add item with quantity unnavailable'
    end

  end

  describe 'wholesale_cart#remove_line_item' do
    let!(:wholesale_line_item) { wholesale_order.wholesale_line_items.last }
    let(:execute) { delete "/api/v2/storefront/wholesale_cart/remove_line_item/#{wholesale_line_item.id}", headers: headers }

    before do
      allow_any_instance_of(Spree::Api::V2::Storefront::WholesaleCartController).to receive(:spree_current_order).and_return(order)
    end

    it_behaves_like 'wholesale order'

    shared_examples 'removes wholesale_line item' do
      before { execute }

      context 'without line items' do
        let!(:wholesale_line_item) { create(:wholesale_line_item) }

        it_behaves_like 'returns 404 HTTP status'
      end

      context 'containing line item' do

        # it_behaves_like 'returns 200 HTTP status'
        # it_behaves_like 'returns valid wholesale_cart JSON'

        it 'removes wholesale_line item from the cart' do
          expect(wholesale_order.wholesale_line_items.count).to eq(14)
        end
      end
    end

    context 'as a signed in user' do
      # include_context 'creates order with line item'

      context 'with existing order' do
        it_behaves_like 'removes wholesale_line item'
      end

      # it_behaves_like 'no current wholesale order'
    end

    context 'as a guest user' do
      before { execute }

      include_context 'creates guest wholesale_order with guest token'

      it_behaves_like 'returns 403 HTTP status'
    end

  end

  describe 'wholesale_cart#empty' do
    let(:execute) { patch '/api/v2/storefront/wholesale_cart/empty', headers: headers }
    
    before do
      allow_any_instance_of(Spree::Api::V2::Storefront::WholesaleCartController).to receive(:spree_current_order).and_return(order)
    end

    shared_examples 'emptying the order' do
      before { execute }

      # it_behaves_like 'returns 200 HTTP status'
      # it_behaves_like 'returns valid wholesale_cart JSON'

      it 'empties the order' do
        expect(wholesale_order.reload.wholesale_line_items.count).to eq(0)
      end
    end

    context 'as a signed in user' do
      
      it_behaves_like 'wholesale order'

      it_behaves_like 'emptying the order'

      it_behaves_like 'no current wholesale order'

    end

    context 'as a guest user' do
      
      context 'with existing guest order with line item' do
        before { execute }
        include_context 'creates guest wholesale_order with guest token'

        it_behaves_like 'returns 404 HTTP status'
      end

      it_behaves_like 'no current wholesale order'
    end
  end
end