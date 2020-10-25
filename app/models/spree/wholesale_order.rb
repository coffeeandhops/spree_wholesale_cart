class Spree::WholesaleOrder < Spree::Base
  # before_validation :update_totals

  belongs_to :order, class_name: "Spree::Order", foreign_key: "order_id"
  has_many :wholesale_line_items, class_name: "Spree::WholesaleLineItem"
  delegate :number, :email, :currency, to: :order

  def update_totals
    self.wholesale_item_total = wholesale_line_items.sum('wholesale_price * quantity')
    self.retail_item_total = wholesale_line_items.sum('retail_price * quantity')
  end

end
