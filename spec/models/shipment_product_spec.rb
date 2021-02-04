require 'rails_helper'

RSpec.describe ShipmentProduct, type: :model do
  before do
    @shipment = FactoryBot.create(:shipment,
                  origin_state: FactoryBot.create(:origin_state),
                  supplier: FactoryBot.create(:supplier))

    @shipment_product = FactoryBot.build(:shipment_product, shipment: @shipment)
  end

  subject { @shipment_product }

  it { should respond_to :shipment }
  it { should respond_to :ddtech_id }
  it { should be_valid }

  context 'when shipment' do
    context 'is not present' do
      before { @shipment_product.shipment_id = nil }
      it { should_not be_valid }
    end

    context 'is not a valid id' do
      before { @shipment_product.shipment_id = 0 }
      it { should_not be_valid }
    end
  end # context when shipment_product end

  context 'when ddtech_id' do
    context 'is not present' do
      before { @shipment_product.ddtech_id = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @shipment_product.ddtech_id = 'q' * 13 }
      it { should_not be_valid }
    end
  end # context when ddtech_id end
end
