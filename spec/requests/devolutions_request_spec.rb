require 'rails_helper'

RSpec.describe 'Admin devolution management', type: :request do
  before do
    @user = FactoryBot.create(:admin_user)
    set_session(user_id: @user.id)
  end
  let!(:dev) { FactoryBot.create(:devolution) }

  it 'GET index' do
    dev2 = FactoryBot.create(:devolution)
    dev3 = FactoryBot.create(:devolution)

    get admin_devolutions_path
    expect(assigns(:devolutions)).to eq([dev3, dev2, dev])

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:index)
  end

  context 'GET show' do
    it 'with an invalid id' do
      get admin_devolution_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      get admin_devolution_path(dev)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(response.body).to include(dev.rma)
    end
  end # context GET show end

  it 'GET new' do
    get new_admin_devolution_path

    expect(assigns(:devolution)).to be_instance_of(Devolution)
    expect(assigns(:devolution)).to be_new_record

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
    expect(response.body).to include(I18n.t('admin.devolutions.new.title'))
  end

  context 'POST create' do
    it 'without parameters' do
      post admin_devolutions_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid parameters' do
      parameters = { devolution: { order_id: '28374' } }
      post admin_devolutions_path, params: parameters

      expect(assigns(:devolution)).not_to be_persisted
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      parameters = { devolution: FactoryBot.build(:devolution).as_json }
      post admin_devolutions_path, params: parameters

      created_devolution = assigns(:devolution)
      expect(created_devolution).to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_devolution_path(created_devolution))

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.devolutions.create.success', devolution: created_devolution))
    end
  end # context POST create

  context 'GET edit' do
    it 'with an invalid id' do
      get edit_admin_devolution_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      get edit_admin_devolution_path(dev)

      expect(assigns(:devolution)).to be_instance_of(Devolution)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('admin.devolutions.edit.title', devolution: dev))
    end
  end # context GET edit end

  context 'PUT update' do
    it 'with an invalid id' do
      put admin_devolution_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'without parameters' do
      put admin_devolution_path(dev)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid parameters' do
      updated_at = dev.updated_at
      put admin_devolution_path(dev), params: { devolution: { order_id: '812973482733' } }

      expect(updated_at).to eq(assigns(:devolution).updated_at)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      updated_at = dev.updated_at
      put admin_devolution_path(dev), params: { devolution: { order_id: '12214' } }

      assert(assigns(:devolution).updated_at > updated_at)
      expect(response).to redirect_to(admin_devolution_path(dev))
      follow_redirect!
      expect(response.body).to include(I18n.t('admin.devolutions.update.success', devolution: assigns(:devolution)))
    end
  end # context PUT update end

  context 'DELETE destroy' do
    it 'with an invalid id' do
      delete admin_devolution_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      other_devolution = FactoryBot.create(:devolution)
      delete admin_devolution_path(other_devolution)

      expect(response).to redirect_to(admin_devolutions_path)
      follow_redirect!
      expect(response.body).to include(I18n.t('admin.devolutions.destroy.success', devolution: other_devolution))
    end
  end # context DELETE destroy
end
