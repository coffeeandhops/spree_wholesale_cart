class Spree::WholesaleOrder < Spree::Base
  # before_validation :update_totals

  belongs_to :order, class_name: "Spree::Order", foreign_key: "order_id"
  has_many :wholesale_line_items, class_name: "Spree::WholesaleLineItem"
  delegate :number, :email, :currency, to: :order

  def update_totals
    self.wholesale_item_total = wholesale_line_items.sum('wholesale_price * quantity')
    self.retail_item_total = wholesale_line_items.sum('retail_price * quantity')
  end

  def is_wholesale?
    # !user.nil? && user.wholesaler? && minimum_order
    minimum_wholesale_order?
  end

  def minimum_wholesale_order?
    # return false if user.nil? || !user.wholesaler?
    minimum = minimum_order_value
    return wholesale_item_total >= minimum unless minimum_order_on_retail
    return retail_item_total >= minimum
  end

  private
  attr_accessor :config_minimum_order_value, :minimum_order_on_retail

  def minimum_order_value
    @config_minimum_order_value ||= ::Spree::WholesaleOrder::Config[:minimum_order]
  end

  def minimum_order_on_retail
    @minimum_order_on_retail ||= ::Spree::WholesaleOrder::Config[:minimum_order_on_retail]
  end

end
