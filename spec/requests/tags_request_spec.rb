require 'rails_helper'

RSpec.describe 'Admin tag management', type: :request do
  before do
    @user = FactoryBot.create(:admin_user)
    set_session(user_id: @user.id)
  end

  it 'GET index' do
    t1 = FactoryBot.create(:tag)
    t2 = FactoryBot.create(:tag)
    t3 = FactoryBot.create(:tag)

    get admin_tags_path
    expect(assigns(:tags)).to eq([t1, t2, t3])

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:index)
    expect(response.body).to match(/<h1.*>Listado de etiquetas<\/h1>/im)
  end

  it 'GET new' do
    get new_admin_tag_path

    expect(assigns(:tag)).to be_instance_of(Tag)
    expect(assigns(:tag)).to be_new_record

    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
  end

  context 'POST create' do
    it 'with no parameters' do
      post admin_tags_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with incomplete parameters' do
      args = { tag: { name: 'tag name' } }
      post admin_tags_path, params: args

      expect(assigns(:tag)).not_to be_persisted
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with complete parameters' do
      args = { tag: { name: 'a new tag', css_class: Tag::STYLES.first } }
      post admin_tags_path, params: args

      tag = assigns(:tag)
      expect(tag).to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_tags_path)

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.tags.create.success', tag: tag))
    end
  end # context POST create end

  context 'GET edit' do
    it 'with an invalid id' do
      get edit_admin_tag_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      tag = FactoryBot.create(:tag)
      get edit_admin_tag_path(tag)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
    end
  end # context GET edit end

  context 'PUT update' do
    let!(:tag) { FactoryBot.create(:tag) }

    it 'with no parameters' do
      put admin_tag_path(tag)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with an invalid id' do
      put admin_tag_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with invalid parameters' do
      args = { tag: { css_class: 'not valid' } }
      updated_at = tag.updated_at
      put admin_tag_path(tag), params: args

      expect(updated_at).to eq(assigns(:tag).updated_at) # changes haven't been saved
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(response.body).to include(I18n.t('labels.form_has_errors'))
    end

    it 'with valid parameters' do
      args = { tag: { name: 'new_tag_name' } }
      updated_at = tag.updated_at
      put admin_tag_path(tag), params: args

      tag = assigns(:tag)
      assert(assigns(:tag).updated_at > updated_at) # it has been updated
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_tags_path)

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.tags.update.success', tag: tag))
    end
  end # context PUT update end

  context 'DELETE destroy' do
    it 'with an invalid id' do
      delete admin_tag_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with a valid id' do
      tag = FactoryBot.create(:tag)
      delete admin_tag_path(tag)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_tags_path)

      follow_redirect!
      expect(response.body).to include(I18n.t('admin.tags.destroy.success', tag: tag))
    end
  end # context DELETE destroy end

end
