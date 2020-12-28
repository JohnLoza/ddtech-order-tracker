require 'rails_helper'

RSpec.describe 'Admin notes management', type: :request do
  before do
    @user = FactoryBot.create(:admin_user)
    set_session(user_id: @user.id)
  end
  let!(:order) { FactoryBot.create(:order, user: @user) }

  context 'POST create' do
    it 'with an invalid id' do
      post admin_order_notes_path(0)
      expect(response).to have_http_status(:not_found)
      expect(response).to render_template('shared/404.html.erb')
    end

    it 'with incomplete parameters' do
      args = { note: { user_id: @user.id } }
      post admin_order_notes_path(order), params: args

      expect(assigns(:note)).not_to be_persisted
      expect(response).to have_http_status(:bad_request)
      assert(JSON.parse(response.body)) # should respond with a json
    end

    it 'with invalid parameters' do
      args = { note: { user_id: 0, message: 'a message' } }
      post admin_order_notes_path(order), params: args

      expect(assigns(:note)).not_to be_persisted
      expect(response).to have_http_status(:bad_request)
      assert(JSON.parse(response.body)) # should respond with a json
    end

    it 'with valid parameters' do
      args = { note: { user_id: @user.id, message: 'a message' } }
      post admin_order_notes_path(order), params: args

      expect(assigns(:note)).to be_persisted
      expect(response).to have_http_status(:ok)
      assert(JSON.parse(response.body)) # should respond with a json
    end
  end # context POST create end

end
