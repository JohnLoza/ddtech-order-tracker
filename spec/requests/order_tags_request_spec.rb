require 'rails_helper'

RSpec.describe 'Admin orders tags management', type: :request do
  before do
    @user = FactoryBot.create(:admin_user)
    set_session(user_id: @user.id)
  end
  let!(:order) { FactoryBot.create(:order, user: @user) }
  let!(:tag) { FactoryBot.create(:tag) }

  context 'POST create' do
    it 'without parameters' do
      post admin_order_order_tags_path(0)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with incomplete parameters' do
      args = { order_tag: { order_id: order.id } }
      post admin_order_order_tags_path(order), params: args

      expect(assigns(:order_tag)).not_to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include('Ocurrió un error al guardar la etiqueta')
    end

    it 'with invalid parameters' do
      args = { order_tag: { order_id: order.id, tag_id: 0 } }
      post admin_order_order_tags_path(order), params: args

      expect(assigns(:order_tag)).not_to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include('Ocurrió un error al guardar la etiqueta')
    end

    it 'with valid parameters' do
      args = { order_tag: { order_id: order.id, tag_id: tag.id } }
      post admin_order_order_tags_path(order), params: args

      expect(assigns(:order_tag)).to be_persisted
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include('Etiqueta guardada')
    end
  end # context POST create end

  context 'DELETE destroy' do
    it 'with invalid ids' do
      delete admin_order_order_tags_path(0, tag.id)
      expect(response).to have_http_status(:not_found)

      delete admin_order_order_tags_path(order.id)
      expect(response).to have_http_status(:not_found)
    end

    it 'with valid ids' do
      OrderTag.create!(order_id: order.id, tag_id: tag.id)
      delete admin_order_order_tag_path(order.id, tag.id)

      expect(response).to have_http_status(:ok)
      assert(JSON.parse(response.body)) # should respond with a JSON
    end
  end # context DELETE destroy end

end
