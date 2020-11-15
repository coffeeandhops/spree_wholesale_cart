require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::Empty do
    let(:wholesale_order) { create(:wholesale_order) }
    let(:wholesale_line_items) { wholesale_order.wholesale_line_items }

    subject { described_class }

    context 'empty a wholesale order' do
      let(:execute) { subject.call wholesale_order: wholesale_order }
      let(:value) { execute.value }

      it do
        expect(wholesale_order.wholesale_line_items.count).to eq(15)
        expect { execute }.to change(WholesaleLineItem, :count)
        expect(execute).to be_success
        expect(wholesale_order.wholesale_item_total).to eq(0.0)
        expect(wholesale_order.retail_item_total).to eq(0.0)
        expect(wholesale_order.wholesale_line_items.count).to eq(0)
      end
    end
  end
end