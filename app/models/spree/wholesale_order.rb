module Spree
  class WholesaleOrder < Spree::Base
    # before_validation :update_totals
    extend ::Spree::DisplayMoney
    
    belongs_to :order, class_name: "Spree::Order", foreign_key: "order_id"
    has_many :wholesale_line_items, class_name: "Spree::WholesaleLineItem"
    has_many :variants, through: :wholesale_line_items

    delegate :number, :email, :currency, :token, to: :order
    
    money_methods :wholesale_item_total, :retail_item_total
    
    if Spree.user_class
      belongs_to :user, class_name: Spree.user_class.to_s, optional: true
    else
      belongs_to :user, optional: true
    end
  
  
    def update_totals
      self.wholesale_item_total = wholesale_line_items.sum('wholesale_price * quantity')
      self.retail_item_total = wholesale_line_items.sum('retail_price * quantity')
      self.item_count += wholesale_line_items.sum(:quantity)
    end
  
    def is_wholesale?
      !user.nil? && user.wholesaler? && minimum_wholesale_order?
    end
  
    def minimum_wholesale_order?
      return false if user.nil? || !user.wholesaler?
      minimum = minimum_order_value
      return wholesale_item_total >= minimum unless minimum_order_on_retail
      return retail_item_total >= minimum
    end
  
    private
    attr_accessor :config_minimum_order_value, :minimum_order_on_retail
  
    def minimum_order_value
      @config_minimum_order_value ||= ::Spree::WholesaleCart::Config[:minimum_order]
    end
  
    def minimum_order_on_retail
      @minimum_order_on_retail ||= ::Spree::WholesaleCart::Config[:minimum_order_on_retail]
    end
  
  end
end
