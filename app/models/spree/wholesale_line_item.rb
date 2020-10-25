class Spree::WholesaleLineItem < Spree::Base
  before_validation :ensure_valid_quantity

  belongs_to :wholesale_order
  belongs_to :variant, class_name: 'Spree::Variant'
  has_one :product, through: :variant


  delegate :order, to: :wholesale_order

  validates :variant, :wholesale_order, presence: true
  validates :quantity, numericality: { only_integer: true, message: Spree.t('validation.must_be_int') }

  validates :wholesale_price, numericality: true
  validates :retail_price, numericality: true

  validate :ensure_proper_currency, if: -> { wholesale_order.present? }

  private
  
  def ensure_valid_quantity
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def ensure_proper_currency
    unless currency == wholesale_order.currency
      errors.add(:currency, :must_match_order_currency)
    end
  end
end
