class Spree::WholesaleOrder < Spree::Base
  belongs_to :order, class_name: "Spree::Order", foreign_key: "order_id"
  has_many :wholesale_line_items, class_name: "Spree::WholesaleLineItem"
  delegate :number, :email, :currency, to: :order
end
