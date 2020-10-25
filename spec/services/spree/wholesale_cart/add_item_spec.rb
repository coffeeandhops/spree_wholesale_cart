require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::AddItem do
    let(:order) { create(:order) }
    let(:wholesale_order) { create(:wholesale_order) }
    let(:variant) { create(:variant) }
    let(:qty) { 2 }
    let(:expected) { WholesaleLineItem.last }

    subject { described_class }

    context 'adds an item to a wholesale order' do
      let(:execute) { subject.call wholesale_order: wholesale_order,  variant: variant, quantity: qty}
      let(:value) { execute.value }

      it do
        expect { execute }.to change(WholesaleLineItem, :count)
        expect(execute).to be_success
        expect(value[:wholesale_line_item]).to eq expected
        expect(expected.quantity).to eq qty
      end
    end

  end
end