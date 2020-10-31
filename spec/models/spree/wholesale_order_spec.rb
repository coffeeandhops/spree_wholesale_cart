require 'spec_helper'

RSpec.describe Spree::WholesaleOrder, type: :model do
  let(:wholesale_order) { create(:wholesale_order) }
  let(:order) { wholesale_order.order }
  # let(:wholesale_order) { Spree::WholesaleOrder.create(order_id: order.id) }

  context "associations" do
    it "should have an order" do
      expect(wholesale_order.order).to_not be(nil)
      expect(order.wholesale_order).to_not be(nil)
      expect(wholesale_order.number).to eq(order.number)
      expect(wholesale_order.email).to eq(order.email)
    end
  end

  context "line items" do
    it "should have line items" do
      expect(wholesale_order.wholesale_line_items.count).to eq(15)
    end
  end

  context "minimum order on wholesale" do
    before do
      Spree::WholesaleOrder::Config[:minimum_order_on_retail] = false
    end
  
    it "should be minimum wholesale order" do
      expect(wholesale_order.minimum_wholsale_order?).to be true
    end

    context "not minimum order" do
      before do
        Spree::WholesaleOrder::Config[:minimum_order] = 10000.0
      end

      it "should not be minimum wholesale order" do
        expect(wholesale_order.minimum_wholsale_order?).to be false
      end
    end

  end

  context "minimum order on retail" do
    before do
      Spree::WholesaleOrder::Config[:minimum_order_on_retail] = true
    end

    it "should be minimum retail order" do
      expect(wholesale_order.minimum_wholsale_order?).to be true
    end

    context "not min retail order" do
      before do
        Spree::WholesaleOrder::Config[:minimum_order] = 5000
      end

      it "should not be minimum retail order" do
        expect(wholesale_order.minimum_wholsale_order?).to be false
      end

    end
  end

end
