require 'rails_helper'

RSpec.describe 'Admin order management', type: :request do
  before do
    @user = FactoryBot.create(:admin_user)
    set_session(user_id: @user.id)
  end
  let!(:order) { FactoryBot.create(:order, user: @user) }

  it 'GET index' do
    order2 = FactoryBot.create(:order, user: @user)
    order3 = FactoryBot.create(:order, user: @user)

    get admin_orders_path
    expect(assigns(:orders)).to eq([order3, order2, order])

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:index)
  end

  context 'GET show' do
    it 'with an invalid id' do
      get admin_order_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      get admin_order_path(order)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(response.body).to include(I18n.t('admin.orders.show.title', order: order.ddtech_key))
    end
  end # context GET show end

  it 'GET arrears' do
    order2 = FactoryBot.create(:order, assemble: true, user: @user)
    get arrears_admin_orders_path

    expect(assigns(:arrears)).to eq([order])
    expect(assigns(:assemble_arrears)).to eq([order2])

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:arrears)
    expect(response.body).to include(I18n.t('admin.orders.arrears.title'))
  end

  it 'GET new' do
    get new_admin_order_path

    expect(assigns(:order)).to be_instance_of(Order)
    expect(assigns(:order)).to be_new_record

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
    expect(response.body).to include(I18n.t('admin.orders.new.title'))
  end

  context 'POST create' do
    it 'without parameters' do
      post admin_orders_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid parameters' do
      parameters = { order: { ddtech_key: '28374' } }
      post admin_orders_path, params: parameters

      expect(assigns(:order)).not_to be_persisted
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      parameters = { order: { ddtech_key: '287323', client_email: 'some@mail.com', parcel: Order::PARCELS.first } }
      post admin_orders_path, params: parameters

      created_order = assigns(:order)
      expect(created_order).to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_admin_order_path)

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.orders.create.success', order: created_order))
    end

    it 'with a note and tag included' do
      tag = FactoryBot.create(:tag)
      parameters = { order: { ddtech_key: '287323', client_email: 'some@mail.com', parcel: Order::PARCELS.first }, note: { message: 'a new note' }, tag: tag.id }

      post admin_orders_path, params: parameters
      expect(assigns(:order).notes.size).to eq(1)
      expect(assigns(:order).tags.size).to eq(1)
    end
  end # context POST create

  context 'GET edit' do
    it 'with an invalid id' do
      get edit_admin_order_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      get edit_admin_order_path(order)

      expect(assigns(:order)).to be_instance_of(Order)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('admin.orders.edit.title', order: order))
    end
  end # context GET edit end

  context 'PUT update' do
    it 'with an invalid id' do
      put admin_order_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'without parameters' do
      put admin_order_path(order)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid parameters' do
      updated_at = order.updated_at
      put admin_order_path(order), params: { order: { ddtech_key: '1221488298381234' } }

      expect(updated_at).to eq(assigns(:order).updated_at)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      updated_at = order.updated_at
      put admin_order_path(order), params: { order: { ddtech_key: '12214' } }

      assert(assigns(:order).updated_at > updated_at)
      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include(I18n.t('admin.orders.update.success', order: '#12214'))
    end
  end # context PUT update end

  context 'DELETE destroy' do
    it 'with an invalid id' do
      delete admin_order_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      other_order = FactoryBot.create(:order, user: @user)
      delete admin_order_path(other_order)

      expect(response).to redirect_to(admin_orders_path)
      follow_redirect!
      expect(response.body).to include(I18n.t('admin.orders.destroy.success', order: other_order))
    end
  end # context DELETE destroy

  context 'PUT update_status' do
    it 'with invalid ddtech_key' do
      put update_status_admin_orders_path, params: { order: { ddtech_key: '22212n' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'with invalid parameters' do
      updated_at = order.updated_at
      put update_status_admin_orders_path, params: { order: { ddtech_key: order.ddtech_key, status: 'not_valid' } }

      expect(updated_at).to eq(assigns(:order).updated_at)
      expect(response).to have_http_status(:bad_request)
      assert(JSON.parse(response.body))
    end

    it 'with valid parameters' do
      updated_at = order.updated_at
      put update_status_admin_orders_path, params: { order: { ddtech_key: order.ddtech_key, status: Order::STATUS[:warehouse_entry] } }

      assert(assigns(:order).updated_at > updated_at)
      expect(response).to have_http_status(:ok)
      assert(JSON.parse(response.body))
    end
  end # context PUT update_status end

  context 'PUT update_guide' do
    it 'with invalid ddtech_key' do
      put update_guide_admin_orders_path, params: { order: { ddtech_key: '22212n' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'with invalid parameters' do
      updated_at = order.updated_at
      put update_guide_admin_orders_path, params: { order: { ddtech_key: order.ddtech_key, guide: ['1238472389472' * 25] } }

      expect(updated_at).to eq(assigns(:order).updated_at)
      expect(response).to have_http_status(:bad_request)
      assert(JSON.parse(response.body))
    end

    it 'with valid parameters' do
      updated_at = order.updated_at
      put update_guide_admin_orders_path, params: { order: { ddtech_key: order.ddtech_key, guide: ['1238472389472'] } }

      assert(assigns(:order).updated_at > updated_at)
      expect(response).to have_http_status(:ok)
      assert(JSON.parse(response.body))
    end

    it 'provider guides user forces guide update even tho the order is "new"' do
      user = FactoryBot.create(:provider_guides_user)
      other_order = FactoryBot.create(:order, user: @user)
      set_session(user_id: user.id)

      put update_guide_admin_orders_path, params: { order: { ddtech_key: other_order.ddtech_key, guide: ['192834823'] } }

      expect(response).to have_http_status(:ok)
      expect(other_order.movements.size).to eq(2) # 2 movements one for creating an order and another for the guide captured
      expect(other_order.notes.last.message).to include('192834823') # a note has been saved noting that a provider guide has been captured
    end
  end # context PUT update_guide end

  context 'PUT hold' do
    it 'with invalid id' do
      put hold_admin_order_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'wit a valid id' do
      put hold_admin_order_path(order), params: { movement: { data: 'message' } }
      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include(I18n.t('admin.orders.hold.success', order: order))
    end
  end # context PUT hold end

  context 'PUT release' do
    it 'with invalid id' do
      put release_admin_order_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'wit a valid id' do
      put release_admin_order_path(order), params: { movement: { data: 'message' } }
      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include(I18n.t('admin.orders.release.success', order: order))
    end
  end # context PUT release end

end
