require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::RemoveLineItem do
    let(:wholesale_order) { create(:wholesale_order) }
    let(:line_item) { wholesale_order.wholesale_line_items.first }
    
    subject { described_class }
    
    context 'remove a line_item from a wholesale order' do
      let(:execute) { subject.call wholesale_order: wholesale_order, line_item: line_item }
      let(:value) { execute.value }

      it do
        current_retail = wholesale_order.retail_item_total
        current_wholesale = wholesale_order.wholesale_item_total

        expect { execute }.to change(WholesaleLineItem, :count)
        wholesale_order.reload
        expect(execute).to be_success
        expect(wholesale_order.wholesale_item_total).to eq(current_wholesale - 100.0)
        expect(wholesale_order.retail_item_total).to eq(current_retail - 200.0)
      end
    end

  end
end