module SpreeWholesaleOrder
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.has_one :wholesaler, class_name: "Spree::Wholesaler", dependent: :destroy
        base.accepts_nested_attributes_for :wholesaler

        base.scope :wholesale, -> { joins(:wholesaler).where("spree_wholesalers.user_id IS NOT NULL") }
      end

      def wholesaler?
        !wholesaler.nil?
      end

    end
  end
end

Spree.user_class.prepend SpreeWholesaleOrder::Spree::UserDecorator

