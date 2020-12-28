require 'rails_helper'

RSpec.describe Tag, type: :model do
  before { @tag = FactoryBot.build(:tag) }
  subject { @tag }

  it { should respond_to :name }
  it { should respond_to :css_class }

  context 'when name' do
    context 'is not present' do
      before { @tag.name = ' ' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @tag.name = 'a' * 26 }
      it { should_not be_valid }
    end
  end # context when name

  context 'when css_class' do
    context 'is not present' do
      before { @tag.css_class = ' ' }
      it { should_not be_valid }
    end

    context 'is not in the styles list' do
      before { @tag.css_class = 'a different style' }
      it { should_not be_valid }
    end

    context 'is in the styles list' do
      before { @tag.css_class = Tag::STYLES.first }
      it { should be_valid }
    end
  end # context when css_class
end
