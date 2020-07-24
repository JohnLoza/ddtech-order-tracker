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
      cannot :update_status, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]

    when User::ROLES[:human_resources]
      can :manage, User
      cannot %i[update destroy], User, role: User::ROLES[:admin]
      can :read, Order

    when User::ROLES[:shipments]
      can :manage, Order, user_id: user.id
      cannot :update_status, Order

    when User::ROLES[:warehouse]
      can :read, Order
      can :update_status, Order, status: Order::STATUS[:new]

    when User::ROLES[:assembler]
      can :read, Order
      can :update_status, Order, status: Order::STATUS[:supplied]

    when User::ROLES[:packer]
      can :read, Order
      can :update_status, Order, status: Order::STATUS[:assembled]

    when User::ROLES[:parcel_guides_generator]
      can :read, Order
      can :update_status, Order, status: Order::STATUS[:supplied]
    end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
