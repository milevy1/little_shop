require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :discount }
    it { should validate_numericality_of(:discount).is_greater_than(0) }
    it { should validate_presence_of :threshold }
    it { should validate_numericality_of(:threshold).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to :user }
  end
end
