require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }

  context 'when valid' do
    it { expect(user).to be_valid }
  end

  context 'when email is empty' do
    before { user.email = '' }
    it { expect(user).to_not be_valid }
  end

  context 'when email is nil' do
    before { user.email = nil }
    it { expect(user).to_not be_valid }
  end

  context 'when invalid email' do
    before { user.email = 'test' }
    it { expect(user).to_not be_valid }
  end

  context 'when password is empty' do
    before { user.password = '' }
    it { expect(user).to_not be_valid }
  end

  context 'when invalid password' do
    before { user.password = 'test' }
    it { expect(user).to_not be_valid }
  end

  context 'when email is taken' do
    before { user.email = 'test@gmail.com' }
    it { expect(user).to_not be_valid }
  end
end
