module Spree
  module DefaultWholesalePrice
    extend ActiveSupport::Concern

    included do
      has_one :default_wholesale_price,
              -> { where currency: Spree::Config[:currency] },
              class_name: 'Spree::WholesalePrice',
              dependent: :destroy

      delegate :display_wholesale_price, :display_wholesale_amount, :wholesale_price, :currency, :wholesale_price=,
               :wholesale_price_including_vat_for, :currency=, to: :find_or_build_default_wholesale_price

      after_save :save_default_wholesale_price

      def default_wholesale_price
        Spree::WholesalePrice.unscoped { super }
      end

      def has_default_wholesale_price?
        !default_wholesale_price.nil?
      end

      def find_or_build_default_wholesale_price
        default_wholesale_price || build_default_wholesale_price
      end

      private

      def default_wholesale_price_changed?
        default_wholesale_price && (default_wholesale_price.changed? || default_wholesale_price.new_record?)
      end

      def save_default_wholesale_price
        default_wholesale_price.save if default_wholesale_price_changed?
      end
    end
  end
end