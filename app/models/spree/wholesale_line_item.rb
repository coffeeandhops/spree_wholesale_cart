class Spree::WholesaleLineItem < Spree::Base
  belongs_to :wholesale_order
  belongs_to :variant, class_name: 'Spree::Variant'
  has_one :product, through: :variant

  delegate :order, to: :wholesale_order
end
