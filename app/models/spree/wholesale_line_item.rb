class Spree::WholesaleLineItem < Spree::Base
  before_validation :ensure_valid_quantity
  extend ::Spree::DisplayMoney

  belongs_to :wholesale_order
  belongs_to :variant, class_name: 'Spree::Variant'
  has_one :product, through: :variant


  delegate :order, to: :wholesale_order

  validates :variant, :wholesale_order, presence: true
  validates :quantity, numericality: { only_integer: true, message: Spree.t('validation.must_be_int') }

  validates :wholesale_price, numericality: true
  validates :retail_price, numericality: true

  validate :ensure_proper_currency, if: -> { wholesale_order.present? }

  validate :validate_stock_quantity
  money_methods :retail_price, :wholesale_price

  def total_wholesale_price
    return 0.0 if variant.nil? || wholesale_price.nil? || quantity.nil?
    wholesale_price * quantity
  end
  
  def total_retail_price
    return 0.0 if variant.nil? || retail_price.nil? || quantity.nil?
    retail_price * quantity
  end

  def display_wholesale_price
    ::Spree::Money.new(wholesale_price, currency: currency)
  end

  def display_total_wholesale_price
    ::Spree::Money.new(total_wholesale_price, currency: currency)
  end

  def display_total_retail_price
    ::Spree::Money.new(total_retail_price, currency: currency)
  end


  private
  
  def ensure_valid_quantity
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def ensure_proper_currency
    unless currency == wholesale_order.currency
      errors.add(:currency, :must_match_order_currency)
    end
  end


  def validate_stock_quantity
    return if item_available?(quantity)

    display_name = variant.name.to_s
    display_name += " (#{variant.options_text})" unless variant.options_text.blank?

    errors[:quantity] << Spree.t(
      :selected_quantity_not_available,
      item: display_name.inspect
    )
  end

  def item_available?(quantity)
    Spree::Stock::Quantifier.new(variant).can_supply?(quantity)
  end

end
