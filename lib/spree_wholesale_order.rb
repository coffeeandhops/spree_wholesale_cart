require 'spree_core'
require 'spree_extension'
require 'spree_wholesale_order/engine'
require 'spree_wholesale_order/version'
require 'geocoder'
module Spree
  module WholesaleOrder
    module_function

    def config(*)
      yield(Spree::WholesaleOrder::Config)
    end
  end
end
