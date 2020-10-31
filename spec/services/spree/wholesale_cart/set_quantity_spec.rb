require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::SetQuantity do
    let(:wholesale_order) { create(:wholesale_order) }
    let(:line_item) { wholesale_order.wholesale_line_items.first }
    let(:quantity) { 5 }
    let(:execute) { subject.call wholesale_order: wholesale_order, line_item: line_item, quantity: quantity }
    let(:value) { execute.value }
    
    subject { described_class }
    
    context 'remove line_item quantity' do

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total

        expect(execute).to be_success
        expect { execute }.to_not change(WholesaleLineItem, :count)
        expect(value[:wholesale_order].wholesale_item_total).to eq(current_wholesale - 50.0)
        expect(value[:wholesale_order].retail_item_total).to eq(current_retail - 100.0)
        expect(value[:wholesale_order].wholesale_line_items.first.quantity).to eq(5)
      end
    end

    context 'add line_item quantity' do
      let(:quantity) { 15 }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total
        expect(line_item.quantity).to eq(10)
        expect(execute).to be_success
        expect { execute }.to_not change(WholesaleLineItem, :count)
        expect(value[:wholesale_order].wholesale_item_total).to eq(current_wholesale + 50.0)
        expect(value[:wholesale_order].retail_item_total).to eq(current_retail + 100.0)
        expect(value[:wholesale_order].wholesale_line_items.first.quantity).to eq(15)
      end
    end

    context 'line_item quantity = zero' do
      let(:quantity) { 0 }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total
        expect(execute).to be_success
        expect { execute }.to_not change(WholesaleLineItem, :count)
        expect(value[:wholesale_order].wholesale_item_total).to eq(current_wholesale - 100.0)
        expect(value[:wholesale_order].retail_item_total).to eq(current_retail - 200.0)
      end
    end

  end
end