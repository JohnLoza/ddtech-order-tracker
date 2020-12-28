require 'rails_helper'

RSpec.describe 'Admin user management', type: :request do
  before do
    @user = FactoryBot.create(:admin_user)
    set_session(user_id: @user.id)
  end

  it 'GET index' do
    u1 = FactoryBot.create(:shipments_user)
    u2 = FactoryBot.create(:warehouse_user)
    u3 = FactoryBot.create(:assemble_boss_user)

    get admin_users_path
    expect(assigns(:users)).to eq([u1, u2, u3])

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:index)
    expect(response.body).to include(I18n.t('admin.users.index.title'))
  end

  context 'GET show' do
    it 'with an invalid id' do
      get admin_user_path(1)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      user = FactoryBot.create(:shipments_user)
      get admin_user_path(user)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(response.body).to include(user.name)
    end
  end # context GET show end

  it 'GET new' do
    get new_admin_user_path

    expect(assigns(:user)).to be_instance_of(User)
    expect(assigns(:user)).to be_new_record

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
    expect(response.body).to include(I18n.t('admin.users.new.title'))
  end


  context 'POST create' do
    it 'with no parameters' do
      post admin_users_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid parameters' do
      args = { user: { email: 'email@mail.com' } }
      post admin_users_path, params: args

      expect(assigns(:user)).not_to be_persisted
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      args = { user: { name: 'a new user', email: 'anemail@mail.com',
        password: 'foobar', password_confirmation: 'foobar',
        role: User::ROLES[:shipments] } }
      post admin_users_path, params: args

      user = assigns(:user)
      expect(user).to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_user_path(user))

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.users.create.success', user: user))
    end
  end # context POST create end

  context 'GET edit' do
    it 'with an invalid id' do
      get edit_admin_user_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      user = FactoryBot.create(:warehouse_user)
      get edit_admin_user_path(user)

      expect(assigns(:user)).to be_instance_of(User)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('admin.users.edit.title', user: user))
    end
  end # context GET edit end

  context 'PUT update' do
    let!(:user) { FactoryBot.create(:shipments_user) }

    it 'with no parameters' do
      put admin_user_path(user)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with an invalid id' do
      put admin_user_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with invalid parameters' do
      args = { user: { email: 'email@ma_il...com' } }
      updated_at = user.updated_at
      put admin_user_path(user), params: args

      expect(updated_at).to eq(assigns(:user).updated_at) # changes haven't been saved
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      args = { user: { name: 'new_user_name' } }
      updated_at = user.updated_at
      put admin_user_path(user), params: args

      user = assigns(:user)
      assert(assigns(:user).updated_at > updated_at) # it has been updated
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_user_path(user))

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.users.update.success', user: user))
    end
  end # context PUT update end

  context 'DELETE destroy' do
    it 'with an invalid id' do
      delete admin_user_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      user = FactoryBot.create(:packer_user)
      delete admin_user_path(user)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_users_path)

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.users.destroy.success', user: user, url: restore_admin_user_path(user)))
      expect(response.body).to match(/<a.*href="#{restore_admin_user_path(user)}"/im)
    end
  end # context DELETE destroy end

  context 'PUT restore' do
    it 'with an invalid id' do
      put restore_admin_user_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      user = FactoryBot.create(:observer_user)
      assert user.active?
      user.destroy
      assert user.inactive?

      put restore_admin_user_path(user)
      expect(assigns(:user)).to be_active
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_user_path(user))

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.users.restore.success', user: user))
    end
  end # context PUT restore end
end
