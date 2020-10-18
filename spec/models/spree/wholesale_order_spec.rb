require 'spec_helper'

RSpec.describe Spree::WholesaleOrder, type: :model do
  let(:order) { create(:order) }
  let(:wholesale_order) { Spree::WholesaleOrder.create(order_id: order.id) }
  
  context "associations" do
    it "should have an order" do
      expect(wholesale_order.order).to_not be(nil)
      expect(order.wholesale_order).to_not be(nil)
      expect(wholesale_order.number).to eq(order.number)
      expect(wholesale_order.email).to eq(order.email)
    end
  end

end
