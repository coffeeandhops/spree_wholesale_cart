module Spree
  class WholesaleOrderConfiguration < Preferences::Configuration
    preference :minimum_order, :decimal, default: 300.0
    preference :minimum_order_on_retail, :boolean, default: false
    preference :allow_under_minimum_checkout, :boolean, default: false
    preference :google_map_api_key, :string, default: ''
  end
end
