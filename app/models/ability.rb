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
    when User::ROLES[:warehouse_boss], User::ROLES[:warehouse_exit], User::ROLES[:pack_boss],
         User::ROLES[:pack_exit]
      update_order_status_permission
    when User::ROLES[:assemble_boss], User::ROLES[:assemble_exit]
      update_order_assembly_status_permission
    when User::ROLES[:digital_guides], User::ROLES[:provider_guides]
      update_order_guide_permission
    when User::ROLES[:support_and_warranty]
      support_and_warranty_permissions(user)
    when User::ROLES[:supplier_shipments]
      supplier_shipments_permissions(user)
    end
  end
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

  def default_permissions
    can :read, Order
    can :create, Note
    can :manage, OrderTag
    can :read, Devolution
    can :read, Shipment
    cannot %i[hold release], Order, status: Order::STATUS[:sent]
  end

  def admin_permissions(user)
    can :manage, :all

    cannot %i[update destroy], User, role: User::ROLES[:admin]
    can :update, User, id: user.id
  end

  def human_resources_permissions(user)
    can :manage, User
    cannot %i[update destroy], User, role: User::ROLES[:admin]
  end

  def shipments_permissions(user)
    can %i[create update hold release], Order
    can :manage, Tag
  end

  def update_order_status_permission
    can :update_status, Order
  end

  def update_order_assembly_status_permission
    can :update_status, Order, assemble: true
  end

  def update_order_guide_permission
    can :update_guide, Order
  end

  def support_and_warranty_permissions(user)
    can [:read, :create], Devolution
    can :update, Devolution
    can :destroy, Devolution, user_id: nil

    can :take, Devolution, user_id: nil
    can :process, Devolution, user_id: user.id, guide_id: nil
    can :resend, Devolution do |d|
      d.actions_taken.present? and d.user_id == user.id and d.guide_id.blank?
    end
  end

  def supplier_shipments_permissions(user)
    can :manage, Shipment
    can :manage, OriginState
    can :manage, Supplier
  end
end
