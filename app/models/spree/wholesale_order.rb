class Spree::WholesaleOrder < Spree::Base
  belongs_to :order, class_name: "Spree::Order", foreign_key: "order_id"

  delegate :number, :email, to: :order
end
