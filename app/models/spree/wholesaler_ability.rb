class Spree::WholesalerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Spree.user_class.new
    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end

end
