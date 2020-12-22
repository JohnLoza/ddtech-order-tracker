require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = FactoryBot.build(:admin_user)
    @order = FactoryBot.build(:order, user: @user)
    @note = FactoryBot.build(:note, user: @user, order: @order)
  end
  subject { @note }

  it { should respond_to :message }
  it { should respond_to :user }
  it { should be_valid }
end
