require 'rails_helper'

RSpec.describe Movement, type: :model do
  before do
    @user = FactoryBot.build(:admin_user)
    @order = FactoryBot.build(:order, user: @user)
    @movement = FactoryBot.build(:movement, user: @user, order: @order)
  end
  subject { @movement }

  it { should respond_to :description }
  it { should respond_to :data }

  it { should respond_to :user }
  it { should respond_to :order }

  it { should be_valid }

  context 'when data is too long' do
    before { @movement.data = 'abcde' * 51 }
    it { should_not be_valid }
  end

  context 'when description' do
    context 'is not present' do
      before { @movement.description = ' ' }
      it { should_not be_valid }
    end

    context 'is not in the DESCRIPTIONS list' do
      before { @movement.description = 'another_description' }
      it { should_not be_valid }
    end

    context 'is in the DESCRIPTONS list' do
      it 'should be valid' do
        descriptions = Movement::DESCRIPTIONS.values
        descriptions.each do |d|
          @movement.description = d
          expect(@movement).to be_valid
        end
      end
    end
  end # context when description end
end
