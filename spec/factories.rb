FactoryBot.define do

  factory :user, class: :User do
    sequence(:name) { |n| "user #{n}" }
    sequence(:email) { |n| "user_#{n}@mail.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    role {}

    factory :admin_user do
      role { User::ROLES[:admin] }
    end

    factory :shipments_user do
      role { User::ROLES[:shipments] }
    end

    factory :warehouse_boss_user do
      role { User::ROLES[:warehouse_boss] }
    end

    factory :warehouse_exit_user do
      role { User::ROLES[:warehouse_exit] }
    end

    factory :warehouse_user do
      role { User::ROLES[:warehouse] }
    end

    factory :assemble_boss_user do
      role { User::ROLES[:assemble_boss] }
    end

    factory :assemble_exit_user do
      role { User::ROLES[:assemble_exit] }
    end

    factory :assembler_user do
      role { User::ROLES[:assembler] }
    end

    factory :pack_boss_user do
      role { User::ROLES[:pack_boss] }
    end

    factory :pack_exit_user do
      role { User::ROLES[:pack_exit] }
    end

    factory :packer_user do
      role { User::ROLES[:packer] }
    end

    factory :digital_guides_user do
      role { User::ROLES[:digital_guides] }
    end

    factory :provider_guides_user do
      role { User::ROLES[:provider_guides] }
    end

    factory :human_resources_user do
      role { User::ROLES[:human_resources] }
    end

    factory :support_user do
      role { User::ROLES[:support_and_warranty] }
    end

    factory :observer_user do
      role { User::ROLES[:observer] }
    end
  end # factory :user end

  factory :order do
    user {}
    sequence(:ddtech_key) { |n| "1212#{n}" }
    client_email { 'lozabucio.jony@gmail.com' }
    status {}
    assemble { false }
    multiple_packages { false }
    urgent { false }
    holding { false }
    parcel { Order::PARCELS.first }
    guide {}
  end

  factory :note, class: :Note do
    user {}
    order {}
    message { 'This is a new note' }
  end # factory :note end

  factory :movement, class: :Movement do
    user {}
    order {}
    description { Movement::DESCRIPTIONS[:new_order] }
    data {}
  end

  factory :tag do
    sequence(:name) { |n| "tag #{n}" }
    css_class { Tag::STYLES[Random.rand(Tag::STYLES.size - 1).to_i] }
  end

  factory :devolution do
    rma {}
    user {}

    sequence(:client_name) { |n| "Client #{n}" }
    sequence(:email) { |n| "client_#{n}@mail.com" }
    sequence(:order_id) { |n| "1212#{n}" }

    telephone { '3312321259' }
    client_type { 'client_type' }
    products { 'produtcs info' }
    description { 'description message' }

    street { 'street' }
    colony { 'colony' }
    zc { '12323' }
    city { 'city name' }
    state { 'state' }

    comments {}
    actions_taken {}
    parcel {}
    guide_id {}
    voucher_folio {}
    voucher_amount {}
    free_guide { false }
  end
end
