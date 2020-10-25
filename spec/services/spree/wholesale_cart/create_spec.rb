require 'spec_helper'
module Spree
  RSpec.describe WholesaleCart::Create do
    let(:order) { create(:order) }
    let(:expected) { WholesaleOrder.first }

    subject { described_class }

    context 'create a wholesale order' do
      let(:execute) { subject.call order: order }
      let(:value) { execute.value }

      it do
        expect { execute }.to change(WholesaleOrder, :count)
        expect(execute).to be_success
        expect(value).to eq expected
        expect(expected.number).to be_present
      end
    end

  end
end