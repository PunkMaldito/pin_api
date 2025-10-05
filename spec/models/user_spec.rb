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
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it 'validates email format' do
      user = build(:user, email: 'invalid-email')
      expect(user).not_to be_valid
    end

    it 'validates role inclusion' do
      user = build(:user, role: 'invalid_role')
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

  describe '#can_sell?' do
    it 'returns true for seller' do
      user = build(:user, :seller)
      expect(user.can_sell?).to be true
    end

    it 'returns true for admin' do
      user = build(:user, :admin)
      expect(user.can_sell?).to be true
    end

    it 'returns false for builder' do
      user = build(:user, :builder)
      expect(user.can_sell?).to be false
    end
  end

  describe '#can_build?' do
    it 'returns true for builder' do
      user = build(:user, :builder)
      expect(user.can_build?).to be true
    end

    it 'returns true for admin' do
      user = build(:user, :admin)
      expect(user.can_build?).to be true
    end

    it 'returns false for seller' do
      user = build(:user, :seller)
      expect(user.can_build?).to be false
    end
  end

  describe '#can_manage_products?' do
    it 'returns true for admin' do
      user = build(:user, :admin)
      expect(user.can_manage_products?).to be true
    end

    it 'returns false for seller' do
      user = build(:user, :seller)
      expect(user.can_manage_products?).to be false
    end

    it 'returns false for builder' do
      user = build(:user, :builder)
      expect(user.can_manage_products?).to be false
    end
  end
end
