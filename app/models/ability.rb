# frozen_string_literal: true

# Defines the permissions per user role
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    default_permissions

    case user.role
    when User::ROLES[:admin]
      admin_permissions(user)
    when User::ROLES[:human_resources]
      human_resources_permissions(user)
    when User::ROLES[:shipments]
      shipments_permissions(user)
    when User::ROLES[:warehouse]
      warehouse_permissions(user)
    when User::ROLES[:assembler]
      assembler_permissions(user)
    when User::ROLES[:packer]
      packer_permissions(user)
    when User::ROLES[:digital_guides]
      digital_guides_permissions(user)
    end
  end
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

  def default_permissions
    can :read, Order
    can :create, Note
  end

  def admin_permissions(user)
    can :manage, :all

    cannot %i[update destroy], User, role: User::ROLES[:admin]
    can :update, User, id: user.id

    cannot :update_status, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
    cannot :update_guide, Order
    can :update_guide, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]

    cannot %i[update_status update_guide], Order, holding: true
    cannot :hold, Order, status: Order::STATUS[:sent]
  end

  def human_resources_permissions(_user)
    can :manage, User
    cannot %i[update destroy], User, role: User::ROLES[:admin]
  end

  def shipments_permissions(user)
    can %i[create update], Order, user_id: user.id
    can [:hold, :release], Order do |order|
      order.user_id == user.id and order.status != Order::STATUS[:sent]
    end
  end

  def warehouse_permissions(_user)
    can :update_status, Order, status: Order::STATUS[:new]
    cannot :update_status, Order, holding: true
  end

  def assembler_permissions(_user)
    can :update_status, Order, status: Order::STATUS[:supplied], assemble: true
    cannot :update_status, Order, holding: true
  end

  def packer_permissions(_user)
    can :update_status, Order, status: Order::STATUS[:assembled], assemble: true
    can :update_status, Order, status: Order::STATUS[:supplied], assemble: false
    cannot :update_status, Order, holding: true
  end

  def digital_guides_permissions(_user)
    can :update_guide, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
    cannot :update_guide, Order, holding: true
  end
end
