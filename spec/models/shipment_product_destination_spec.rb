require 'rails_helper'

RSpec.describe ShipmentProductDestination, type: :model do
  before do
    @shipment = FactoryBot.create(:shipment,
                  origin_state: FactoryBot.create(:origin_state),
                  supplier: FactoryBot.create(:supplier))

    @shipment_product = FactoryBot.create(:shipment_product, shipment: @shipment)
    @spd = FactoryBot.build(:shipment_product_destination, shipment_product: @shipment_product)
  end

  subject { @spd }

  it { should respond_to :shipment_product }
  it { should respond_to :destination }
  it { should respond_to :units }
  it { should be_valid }

  context 'when shipment_product' do
    context 'is not present' do
      before { @spd.shipment_product_id = nil }
      it { should_not be_valid }
    end

    context 'is not a valid id' do
      before { @spd.shipment_product_id = 0 }
      it { should_not be_valid }
    end
  end # context when shipment_product end

  context 'when destination' do
    context 'is not present' do
      before { @spd.destination = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @spd.destination = 'q' * 51 }
      it { should_not be_valid }
    end
  end # context when destination end

  context 'when units' do
    context 'is not present' do
      before { @spd.units = nil }
      it { should_not be_valid }
    end

    context 'is less than zero' do
      before { @spd.units = -10 }
      it { should_not be_valid }
    end

    context 'is equal to zero' do
      before { @spd.units = 0 }
      it { should_not be_valid }
    end

    context 'is greater than one' do
      before { @spd.units = 10 }
      it { should be_valid }
    end

    context 'is equal to one' do
      before { @spd.units = 1 }
      it { should be_valid }
    end
  end # context when units end
end
