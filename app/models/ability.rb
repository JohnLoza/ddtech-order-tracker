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
    when User::ROLES[:warehouse_boss]
      warehouse_boss_permissions(user)
    when User::ROLES[:warehouse_exit]
      warehouse_exit_permissions(user)
    when User::ROLES[:assemble_boss]
      assemble_boss_permissions(user)
    when User::ROLES[:assemble_exit]
      assemble_exit_permissions(user)
    when User::ROLES[:pack_boss]
      pack_boss_permissions(user)
    when User::ROLES[:pack_exit]
      pack_exit_permissions(user)
    when User::ROLES[:digital_guides]
      digital_guides_permissions(user)
    end

    cannot %i[update_status update_guide], Order, holding: true # no one can
  end
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

  def default_permissions
    can :read, Order
    can :create, Note
    can :manage, OrderTag
  end

  def admin_permissions(user)
    can :manage, :all

    cannot %i[update destroy], User, role: User::ROLES[:admin]
    can :update, User, id: user.id

    cannot :update_status, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
    can :update_status, Order, multiple_packages: true
    cannot :update_guide, Order
    can :update_guide, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
    can :update_guide, Order, multiple_packages: true

    cannot [:hold, :release], Order, status: Order::STATUS[:sent]
  end

  def human_resources_permissions(user)
    can :manage, User
    cannot %i[update destroy], User, role: User::ROLES[:admin]
  end

  def shipments_permissions(user)
    can %i[create update], Order, user_id: user.id
    can [:hold, :release], Order do |order|
      order.user_id == user.id and order.status != Order::STATUS[:sent]
    end
    can :manage, Tag
  end

  def warehouse_boss_permissions(user)
    can :update_status, Order,
      status: [Order::STATUS[:new], Order::STATUS[:warehouse_entry]]
    can :update_status, Order, multiple_packages: true
  end

  def warehouse_exit_permissions(user)
    can :update_status, Order, status: Order::STATUS[:warehouse_entry]
    can :update_status, Order, multiple_packages: true
  end

  def assemble_boss_permissions(user)
    can :update_status, Order, assemble: true,
      status: [Order::STATUS[:supplied], Order::STATUS[:assemble_entry]]
    can :update_status, Order, assemble: true, multiple_packages: true
  end

  def assemble_exit_permissions(user)
    can :update_status, Order, assemble: true, status: Order::STATUS[:assemble_entry]
    can :update_status, Order, assemble: true, multiple_packages: true
  end

  def pack_boss_permissions(user)
    can :update_status, Order, status: Order::STATUS[:assembled], assemble: true
    can :update_status, Order, status: Order::STATUS[:supplied], assemble: false
    can :update_status, Order, multiple_packages: true
  end

  def pack_exit_permissions(user)
    can :update_status, Order, status: Order::STATUS[:assembled], assemble: true
    can :update_status, Order, status: Order::STATUS[:supplied], assemble: false
    can :update_status, Order, multiple_packages: true
  end

  def digital_guides_permissions(user)
    can :update_guide, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
    can :update_guide, Order, multiple_packages: true
  end
end
