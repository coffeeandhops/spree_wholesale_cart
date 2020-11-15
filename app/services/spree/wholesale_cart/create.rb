module Spree
  module WholesaleCart
    class Create
      prepend Spree::ServiceModule::Base

      def call(order:)

        wholesale_order = Spree::WholesaleOrder.create!(order: order)
        success(wholesale_order)
      end
    end
  end
end
