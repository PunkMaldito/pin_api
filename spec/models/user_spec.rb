require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      user = build(:user, name: nil)

      expect(user).not_to be_valid
    end

    it 'validates presence of email' do
      user = build(:user, email: nil)

      expect(user).not_to be_valid
    end

    it 'validates uniqueness of email' do
      create(:user, email: 'test@test.com')
      user = build(:user, email: 'test@test.com')

      expect(user).not_to be_valid
    end
  end

  describe 'roles' do
    it 'has seller role by default' do
      user = create(:user)

      expect(user.role).to eq('seller')
    end

    it 'can have builder role' do
      user = create(:user, :builder)

      expect(user.role).to eq('builder')
    end

    it 'can have admin role' do
      user = create(:user, :admin)

      expect(user.role).to eq('admin')
    end
  end
end
