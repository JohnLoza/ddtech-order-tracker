require 'rails_helper'

RSpec.describe Shipment, type: :model do
  before do
    @origin = FactoryBot.create(:origin_state)
    @supplier = FactoryBot.create(:supplier)

    @shipment = FactoryBot.build( :shipment,
      origin_state: @origin, supplier: @supplier)
  end
  subject { @shipment }

  it { should respond_to :hash_id }
  it { should respond_to :estimated_arrival }
  it { should respond_to :comments }
  it { should respond_to :status }
  it { should respond_to :origin_state }
  it { should respond_to :supplier }
  it { should respond_to :shipment_products }
  it { should be_valid }

  context 'when hash_id' do
    context 'is too long' do
      before { @shipment.hash_id = 'a' * 13 }
      it { should_not be_valid }
    end

    context 'when its already taken' do
      before do
        another_shipment = FactoryBot.create(:shipment,
          origin_state: @origin, supplier: @supplier)
        @shipment.hash_id = another_shipment.hash_id
      end

      it {should_not be_valid }
    end
  end # context when hash_id end

  it 'when comments is too long' do
    @shipment.comments = 'b' * 251
    expect(@shipment).not_to be_valid
  end

  context 'when status' do
    context 'is not in the STATUSES list' do
      before { @shipment.status = 'some status' }
      it { should_not be_valid }
    end

    context 'is in the STATUSES list' do
      before { @shipment.status = Shipment::STATUSES.first }
      it { should be_valid }
    end
  end # context when status end

  it 'when estimated_arrival is not present' do
    @shipment.estimated_arrival = nil
    expect(@shipment).not_to be_valid
  end

  context 'when origin_state' do
    context 'is not present' do
      before { @shipment.origin_state_id = nil }
      it { should_not be_valid }
    end

    context 'is not a valid id' do
      before { @shipment.origin_state_id = 0 }
      it { should_not be_valid }
    end
  end # context when origin_state end

  context 'when supplier' do
    context 'is not present' do
      before { @shipment.supplier_id = nil }
      it { should_not be_valid }
    end

    context 'is not a valid id' do
      before { @shipment.supplier_id = 0 }
      it { should_not be_valid }
    end
  end # context when supplier end

  it 'when estimated_arrival is not present' do
    @shipment.estimated_arrival = nil
    expect(@shipment).not_to be_valid
  end
end
