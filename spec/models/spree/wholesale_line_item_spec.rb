require 'spec_helper'

RSpec.describe Spree::WholesaleLineItem, type: :model do
  let(:order) { create :wholesale_order }
  let(:line_item) { order.wholesale_line_items.first }

  # before { create(:store) }

  describe 'Validations' do
    describe 'ensure_proper_currency' do
      context 'order is present' do
        context "when line_item's currency matches with order's" do
          it { expect(line_item).to be_valid }
        end

        context "when line_item's currency does not matches with order's" do
          before do
            line_item.currency = 'Invalid Currency'
          end

          it { expect(line_item).not_to be_valid }
        end
      end
    end
  end

  describe '#ensure_valid_quantity' do
    context 'quantity.nil?' do
      before do
        line_item.quantity = nil
        line_item.valid?
      end

      it { expect(line_item.quantity).to be_zero }
    end

    context 'quantity < 0' do
      before do
        line_item.quantity = -1
        line_item.valid?
      end

      it { expect(line_item.quantity).to be_zero }
    end

    context 'quantity = 0' do
      before do
        line_item.quantity = 0
        line_item.valid?
      end

      it { expect(line_item.quantity).to be_zero }
    end

    context 'quantity > 0' do
      let(:original_quantity) { 1 }

      before do
        line_item.quantity = original_quantity
        line_item.valid?
      end

      it { expect(line_item.quantity).to eq(original_quantity) }
    end
  end

end
