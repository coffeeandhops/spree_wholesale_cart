require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::RemoveItem do
    let(:wholesale_order) { create(:wholesale_order) }
    let(:line_item) { wholesale_order.wholesale_line_items.first }
    let(:variant) { line_item.variant }
    
    subject { described_class }
    
    context 'remove an entire line_item from a wholesale order' do
      let(:execute) { subject.call wholesale_order: wholesale_order, variant: variant, quantity: 10 }
      let(:value) { execute.value }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total
        current_item_count = wholesale_order.item_count

        expect { execute }.to change(WholesaleLineItem, :count)
        wholesale_order.reload
        expect(execute).to be_success
        expect(wholesale_order.wholesale_line_items.count).to eq(14)
        expect(wholesale_order.wholesale_item_total).to eq(current_wholesale - 100.0)
        expect(wholesale_order.retail_item_total).to eq(current_retail - 200.0)
        expect(wholesale_order.item_count).to eq(current_item_count - 10)
      end
    end

    context 'change the line_item quantity' do
      let(:quantity) { 5 }
      let(:execute) { subject.call wholesale_order: wholesale_order, variant: variant, quantity: quantity }
      let(:value) { execute.value }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total
        current_item_count = wholesale_order.item_count

        expect { execute }.to_not change(WholesaleLineItem, :count)
        wholesale_order.reload
        expect(execute).to be_success
        expect(value.quantity).to be(5)
        expect(wholesale_order.wholesale_line_items.count).to eq(15)
        expect(wholesale_order.wholesale_item_total).to eq(current_wholesale - 50.0)
        expect(wholesale_order.retail_item_total).to eq(current_retail - 100.0)
        expect(wholesale_order.item_count).to eq(current_item_count - quantity)
      end

      context 'with invalid quanities' do
        let(:quantity) { 15 }
        
        it "should remove the line_item if quantity is greater than line_item.quantity" do
  
          current_retail = wholesale_order.retail_item_total
          current_wholesale = wholesale_order.wholesale_item_total
  
          expect { execute }.to change(WholesaleLineItem, :count)
          wholesale_order.reload
          expect(execute).to be_success
          expect(wholesale_order.wholesale_line_items.count).to eq(14)
          expect(wholesale_order.wholesale_item_total).to eq(current_wholesale - 100.0)
          expect(wholesale_order.retail_item_total).to eq(current_retail - 200.0)
        end
      end

      context 'locked wholesale order' do
        before do
          wholesale_order.update_columns(locked: true)
          execute
        end

        it do
          expect(execute).to_not be_success
        end
      end

    end

  end
end