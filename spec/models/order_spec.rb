require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    @user = FactoryBot.create(:admin_user)
    @order = FactoryBot.build(:order, user: @user)
  end
  subject { @order }

  it { should respond_to :ddtech_key }
  it { should respond_to :client_email }
  it { should respond_to :parcel }
  it { should respond_to :guide }
  it { should respond_to :status }
  it { should respond_to :assemble }
  it { should respond_to :multiple_packages }
  it { should respond_to :urgent }
  it { should respond_to :holding }

  it { should respond_to :updater_id }
  it { should respond_to :data }
  it { should respond_to :force_status_update }
  it { should respond_to :updating_status }

  it { should respond_to :user }
  it { should respond_to :movements }
  it { should respond_to :notes }
  it { should respond_to :order_tags }
  it { should respond_to :tags }

  it { should be_valid }

  context 'when client_email' do
    context 'is not present' do
      before { @order.client_email = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @order.client_email = "#{'e'*23}@#{'m'*23}.com" }
      it { should_not be_valid }
    end

    context 'format is invalid' do
      it 'should not be valid' do
        client_emails = %w[user@foo,com user_at_foo.org example.user@foo.
                    foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        client_emails.each do |e|
          @order.client_email = e
          expect(@order).not_to be_valid
        end
      end
    end

    context 'format is valid' do
      it 'should be valid' do
        emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        emails.each do |e|
          @order.client_email = e
          expect(@order).to be_valid
        end
      end
    end
  end # context when client_email end

  context 'when ddtech_key' do
    context 'is not present' do
      before { @order.ddtech_key = ' ' }
      it { should_not be_valid }
    end

    context 'is too short' do
      before { @order.ddtech_key = '1212' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @order.ddtech_key = '12'*7 }
      it { should_not be_valid }
    end

    context 'is already taken' do
      it 'should not be valid' do
        another_order = FactoryBot.build(:order, user: @user)
        another_order.save!
        @order.ddtech_key = another_order.ddtech_key
        expect(@order).not_to be_valid
      end
    end

    context 'is already taken with different casing' do
      it 'should not be valid' do
        another_order = FactoryBot.build(:order, user: @user)
        another_order.ddtech_key = 'abs12c'
        another_order.save!
        @order.ddtech_key = another_order.ddtech_key.upcase # upcase and set the same key
        expect(@order).not_to be_valid
      end
    end
  end # context when ddtech_key end

  context 'when status' do
    context 'is not in the STATUSES list' do
      before { @order.status = 'another_status' }
      it { should_not be_valid }
    end

    context 'is not the next one to be processed' do
      it 'should not be valid' do
        @order.save! # as a new order its status is 'new'
        # next one should be warehouse_entry
        # statuses go from new > warehouse_entry > supplied > if assemble?
        #                                                       assemble_entry > assembled > packed > sent
        #                                                     else
        #                                                       packed > sent
        @order.status = Order::STATUS[:supplied]
        expect(@order).not_to be_valid
      end
    end

    context 'changes to assemble_entry' do
      before do
        @order.save!
        @order.update!(status: Order::STATUS[:warehouse_entry])
        @order.update!(status: Order::STATUS[:supplied])
      end

      context 'and assemble is set to false' do
        before do
          @order.update!(assemble: false)
          @order.status = Order::STATUS[:assemble_entry]
        end
        it { should_not be_valid }
      end

      context 'and assemble is set to true' do
        before do
          @order.update!(assemble: true)
          @order.status = Order::STATUS[:assemble_entry]
        end
        it { should be_valid }
      end
    end

    context 'changes and order is holded back' do
      it 'should not be valid' do
        @order.holding = true
        @order.save!
        @order.status = Order::STATUS[:warehouse_entry]
        expect(@order).not_to be_valid
      end
    end
  end # context when status end

  context 'when parcel' do
    context 'is not in the PARCELS list' do
      before { @order.parcel = 'another_parcel' }
      it { should_not be_valid }
    end

    context 'is in the PARCELS list' do
      it 'should be valid' do
        parcels = Order::PARCELS
        parcels.each do |p|
          @order.parcel = p
          expect(@order).to be_valid
        end
      end
    end
  end # context when parcel end

  context 'when guide' do
    context 'is too long' do
      before { @order.guide = '12345' * 51 }
      it { should_not be_valid }
    end
  end # context when guide end

end
