require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryBot.build(:admin_user) }
  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :role }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

  it { should respond_to :orders }
  it { should respond_to :movements }
  it { should respond_to :notes }

  it { should respond_to :admin? }
  it { should respond_to :role? }

  it { should be_admin }
  it { should be_valid }

  context 'when name' do
    context 'is not present' do
      before { @user.name = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @user.name = 'e' * 51 }
      it { should_not be_valid }
    end
  end # context when name end

  context 'when password' do
    context 'is not present' do
      it 'should not be valid' do
        @user.password = ' '
        @user.password_confirmation = @user.password
        expect(@user).not_to be_valid
      end
    end

    context 'is too long' do
      before { @user.password = 'p' * 21 }
      it { should_not be_valid }
    end

    context 'confirmation is not present' do
      before { @user.password_confirmation = ' ' }
      it { should_not be_valid }
    end

    context '& confirmation do not match' do
      before { @user.password_confirmation = 'other password' }
      it { should_not be_valid }
    end
  end # context when password end

  context 'when role' do
    context 'is not present' do
      before { @user.role = ' ' }
      it { should_not be_valid }
    end

    context 'is not present in the ROLES list' do
      before { @user.role = 'invalid role' }
      it { should_not be_valid }
    end
  end # contect when role end

  context 'when email' do
    context 'is not present' do
      before { @user.email = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @user.email = "#{'e'*23}@#{'m'*23}.com" }
      it { should_not be_valid }
    end

    context 'format is invalid' do
      it 'should not be valid' do
        emails = %w[user@foo,com user_at_foo.org example.user@foo.
                    foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        emails.each do |e|
          @user.email = e
          expect(@user).not_to be_valid
        end
      end
    end

    context 'format is valid' do
      it 'should be valid' do
        emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        emails.each do |e|
          @user.email = e
          expect(@user).to be_valid
        end
      end
    end

    context 'is already taken' do
      it 'should not be valid' do
        another_user = FactoryBot.build(:admin_user)
        another_user.save
        @user.email = another_user.email
        expect(@user).not_to be_valid
      end
    end
  end # context when email end

end
