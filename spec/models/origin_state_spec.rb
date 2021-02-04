require 'rails_helper'

RSpec.describe OriginState, type: :model do
  before { @origin_state = FactoryBot.build(:origin_state) }
  subject { @origin_state }

  it { should respond_to :name }
  it { should respond_to :estimated_shipment_days }
  it { should be_valid }

  it 'name is not present' do
    @origin_state.name = ' '
    expect(@origin_state).not_to be_valid
  end

  context 'when estimated_shipment_days' do
    it 'is not present' do
      @origin_state.estimated_shipment_days = nil
      expect(@origin_state).not_to be_valid
    end

    it 'is less than or equal to zero' do
      @origin_state.estimated_shipment_days = -1
      expect(@origin_state).not_to be_valid

      @origin_state.estimated_shipment_days = 0
      expect(@origin_state).not_to be_valid
    end
  end
end
