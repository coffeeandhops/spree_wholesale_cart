require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::AddToOrder do
    let(:wholesale_order) { create(:wholesale_order) }
    let(:order) { wholesale_order.order }
    let(:default_wholesale_total) { 1500.0 }
    let(:default_retail_total) { 3000.0 }
    subject { described_class }

    context 'adds wholesale line_items to order' do
      let(:execute) { subject.call wholesale_order: wholesale_order }
      let(:value) { execute.value }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total
        expect { execute }.to change(LineItem, :count)

        expect(execute).to be_success
        expect(order.line_items.count).to eq(wholesale_order.wholesale_line_items.count)
        expect(order.total).to eq(default_wholesale_total)
      end

      context 'orders under min' do
        let(:wholesale_order) { create(:wholesale_order, line_items_quantity: 1) }
        
        it "should fail" do
          expect(execute).to be_failure
        end

        context "allow checkout under min" do
          before do
            Spree::WholesaleOrder::Config[:allow_under_minimum_checkout] = true
          end
  
          it "should succeed" do
            expect(execute).to be_success
            expect(order.total).to eq(15 * 20)
          end

        end
      end

    end
  end
end