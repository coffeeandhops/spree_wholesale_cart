module Spree
  class WholesalePrice < Spree::Base
    include VatPriceCalculation

    acts_as_paranoid

    MAXIMUM_AMOUNT = BigDecimal('99_999_999.99')

    belongs_to :variant, class_name: 'Spree::Variant', inverse_of: :wholesale_prices, touch: true

    before_validation :ensure_currency

    validates :amount, allow_nil: true, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: MAXIMUM_AMOUNT
    }

    alias_attribute :price, :amount
    alias_attribute :wholesale_price, :amount
    alias_attribute :wholesale_price=, :price=

    extend DisplayMoney
    money_methods :amount, :price, :wholesale_price

    self.whitelisted_ransackable_attributes = ['amount']

    def money
      Spree::Money.new(amount || 0, currency: currency)
    end

    def amount=(amount)
      self[:amount] = Spree::LocalizedNumber.parse(amount)
    end

    def wholesale_price_including_vat_for(price_options)
      options = price_options.merge(tax_category: variant.tax_category)
      gross_amount(price, options)
    end

    def display_wholesale_price_including_vat_for(price_options)
      Spree::Money.new(wholesale_price_including_vat_for(price_options), currency: currency)
    end

    # Remove variant default_scope `deleted_at: nil`
    def variant
      Spree::Variant.unscoped { super }
    end

    private

    def ensure_currency
      self.currency ||= Spree::Config[:currency]
    end
  end
end