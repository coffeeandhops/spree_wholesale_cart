require 'spree_core'
require 'spree_extension'
require 'spree_wholesale_cart/engine'
require 'spree_wholesale_cart/version'
require 'geocoder'
module Spree
  module WholesaleCart
    module_function

    def config(*)
      yield(Spree::WholesaleCart::Config)
    end
  end
end
