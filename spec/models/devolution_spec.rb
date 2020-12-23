require 'rails_helper'

RSpec.describe Devolution, type: :model do
  before { @dev = FactoryBot.build(:devolution) }
  subject { @dev }

  it { should respond_to :rma }
  it { should respond_to :user }

  it { should respond_to :client_name }
  it { should respond_to :email }
  it { should respond_to :order_id }
  it { should respond_to :telephone }
  it { should respond_to :client_type }
  it { should respond_to :products }
  it { should respond_to :description }

  it { should respond_to :street }
  it { should respond_to :colony }
  it { should respond_to :zc }
  it { should respond_to :city }
  it { should respond_to :state }

  it { should respond_to :comments }
  it { should respond_to :actions_taken }
  it { should respond_to :parcel }
  it { should respond_to :guide_id }
  it { should respond_to :voucher_folio }
  it { should respond_to :voucher_amount }
  it { should respond_to :free_guide }

  it { should respond_to :address }
  it { should respond_to :last_order_guide }
  it { should respond_to :free_guide_electible? }

  it { should be_valid }

  context 'when rma' do
    let!(:another_dev) { FactoryBot.create(:devolution) }

    context 'is already taken' do
      it 'should not be valid' do
        @dev.rma = another_dev.rma
        expect(@dev).not_to be_valid
      end
    end

    context 'is already taken with different casing' do
      it 'should not be valid' do
        @dev.rma = another_dev.rma.downcase
        expect(@dev).not_to be_valid
      end
    end

    context 'is unique' do
      it { should be_valid }
    end
  end # context when rma end

  context 'when client_name' do
    context 'is not present' do
      before { @dev.client_name = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @dev.client_name = 'a' * 61 }
      it { should_not be_valid }
    end
  end # context when client_name end

  context 'when email' do
    context 'is not present' do
      before { @dev.email = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @dev.email = "#{'e'*23}@#{'m'*23}.com" }
      it { should_not be_valid }
    end

    context 'format is invalid' do
      it 'should not be valid' do
        emails = %w[user@foo,com user_at_foo.org example.user@foo.
                    foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        emails.each do |e|
          @dev.email = e
          expect(@dev).not_to be_valid
        end
      end
    end

    context 'format is valid' do
      it 'should be valid' do
        emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        emails.each do |e|
          @dev.email = e
          expect(@dev).to be_valid
        end
      end
    end
  end # context when email end

  context 'when street' do
    context 'is not present' do
      before { @dev.street = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.street = 'a' * 61 }
      it { should_not be_valid }
    end
  end # context when street end

  context 'when colony' do
    context 'is not present' do
      before { @dev.colony = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.colony = 'a' * 41 }
      it { should_not be_valid }
    end
  end # context when colony end

  context 'when zc' do
    context 'is not present' do
      before { @dev.zc = ' ' }
      it { should_not be_valid }
    end

    context 'is less than 5 characters length' do
      before { @dev.zc = '1234' }
      it { should_not be_valid }
    end

    context 'is more than 5 characters length' do
      before { @dev.zc = '123456' }
      it { should_not be_valid }
    end
  end # context when zc end

  context 'when city' do
    context 'is not present' do
      before { @dev.city = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.city = 'a' * 26 }
      it { should_not be_valid }
    end
  end # context when city end

  context 'when state' do
    context 'is not present' do
      before { @dev.state = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.state = 'a' * 16 }
      it { should_not be_valid }
    end
  end # context when state end

  context 'when telephone' do
    context 'is not present' do
      before { @dev.telephone = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.telephone = 'a' * 16 }
      it { should_not be_valid }
    end
  end # context when telephone end

  context 'when order_id' do
    context 'is not present' do
      before { @dev.order_id = ' ' }
      it { should_not be_valid }
    end

    context 'is less than 5 characters length' do
      before { @dev.order_id = '1234' }
      it { should_not be_valid }
    end

    context 'is more than 6 characters length' do
      before { @dev.order_id = '1234567' }
      it { should_not be_valid }
    end
  end # context when order_id end

  context 'when client_type' do
    context 'is not present' do
      before { @dev.client_type = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.client_type = 'a' * 251 }
      it { should_not be_valid }
    end
  end # context when client_type end

  context 'when products' do
    context 'is not present' do
      before { @dev.products = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.products = 'a' * 251 }
      it { should_not be_valid }
    end
  end # context when products end

  context 'when description' do
    context 'is not present' do
      before { @dev.description = ' ' }
      it { should_not be_valid }
    end

    context 'is too large' do
      before { @dev.description = 'a' * 251 }
      it { should_not be_valid }
    end
  end # context when description end

  context 'when comments is too large' do
    before { @dev.comments = 'a' * 251 }
    it { should_not be_valid }
  end # context when comments end

  context 'when actions_taken is too large' do
    before { @dev.actions_taken = 'a' * 251 }
    it { should_not be_valid }
  end # context when actions_taken end

  context 'when parcel is too large' do
    before { @dev.parcel = 'a' * 251 }
    it { should_not be_valid }
  end # context when parcel end

  context 'when guide_id is too large' do
    before { @dev.guide_id = 'a' * 251 }
    it { should_not be_valid }
  end # context when guide_id end

  context 'Parcel & Guide ID' do
    it 'should be both present or not present' do
      @dev.parcel = ' '
      @dev.guide_id = 221234234
      expect(@dev).not_to be_valid

      @dev.parcel = Order::PARCELS.first
      @dev.guide_id = ' '
      expect(@dev).not_to be_valid

      @dev.guide_id = 288374298374
      expect(@dev).to be_valid
    end
  end # context Parcel & Guide ID end

  context 'when voucher_folio is too large' do
    before { @dev.voucher_folio = '2' * 11 }
    it { should_not be_valid }
  end

  context 'when voucher_amount' do
    context 'is not greater than zero' do
      before { @dev.voucher_amount = 0 }
      it { should_not be_valid }
    end

     context 'is greater than 999,999' do
       before { @dev.voucher_amount = 1000000 }
       it { should_not be_valid }
     end
  end # context when voucher_amount end

  context 'Voucher Folio & Amount' do
    it 'should be both present or not present' do
      @dev.voucher_folio = ' '
      @dev.voucher_amount = 1200
      expect(@dev).not_to be_valid

      @dev.voucher_folio = 88923
      @dev.voucher_amount = nil
      expect(@dev).not_to be_valid

      @dev.voucher_amount = 3800.99
      expect(@dev).to be_valid
    end
  end # context Voucher Folio & Amount end

end
