require 'rails_helper'

RSpec.describe Supplier, type: :model do
  before { @supplier = FactoryBot.build(:supplier) }
  subject { @supplier }

  it { should respond_to :name }
  it { should respond_to :deleted_at }
  it { should be_valid }

  context 'when name' do
    context 'is not present' do
      before { @supplier.name = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @supplier.name = 'a' * 51 }
      it { should_not be_valid }
    end
  end # context when name
end
