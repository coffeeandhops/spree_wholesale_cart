module SpreeWholesaleOrder
  module Spree

    class AbilityDecorator
      include CanCan::Ability
      def initialize(user)
        if user.respond_to?(:wholesaler?) && user.wholesaler?
          can [:create, :update, :show], ::Spree::WholesaleOrder
        end
      end
    end
  end
end

Spree::Ability.register_ability(SpreeWholesaleOrder::Spree::AbilityDecorator)
