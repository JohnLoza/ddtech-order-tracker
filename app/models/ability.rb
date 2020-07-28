# frozen_string_literal: true

# Defines the permissions per user role
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    default_permissions()

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
    when User::ROLES[:parcel_guides_generator]
      parcel_guides_generator_permissions(user)
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

    cannot :update_guide, Order
    can :update_guide, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
  end

  def human_resources_permissions(user)
    can :manage, User
    cannot %i[update destroy], User, role: User::ROLES[:admin]
  end

  def shipments_permissions(user)
    can :manage, Order, user_id: user.id
    cannot :update_status, Order
    cannot :update_guide, Order
  end

  def warehouse_permissions(user)
    can :update_status, Order, status: Order::STATUS[:new]
  end

  def assembler_permissions(user)
    can :update_status, Order, status: Order::STATUS[:supplied]
  end

  def packer_permissions(user)
    can :update_status, Order, status: Order::STATUS[:assembled]
  end

  def parcel_guides_generator_permissions(user)
    can :update_guide, Order, status: [Order::STATUS[:sent], Order::STATUS[:packed]]
  end

end
