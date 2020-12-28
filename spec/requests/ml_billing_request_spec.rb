require 'rails_helper'

RSpec.describe 'ML Billing data', type: :request do
  it 'GET new' do
    get new_ml_billing_path
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:new)
  end

  context 'POST create' do
    it 'without params' do
      post ml_billings_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with valid params' do
      post ml_billings_path, params: { ml_billing: { name: 'this', pseudonym: 'that', ml_folio: '88374293' } }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:create)
    end
  end
end
