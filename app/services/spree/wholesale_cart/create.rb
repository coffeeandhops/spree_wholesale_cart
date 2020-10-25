module Spree
  module WholesaleCart
    class Create
      prepend Spree::ServiceModule::Base

      def call(order:)

        order = Spree::WholesaleOrder.create!(order: order)
        success(order)
      end
    end
  end
end
