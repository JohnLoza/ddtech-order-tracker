# frozen_string_literal: true

# Defines the permissions per user role
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    case user.role
    when User::ROLES[:admin]

      can :manage, :all
      cannot %i[update destroy], User, role: User::ROLES[:admin]
      can :update, User, id: user.id

    end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
