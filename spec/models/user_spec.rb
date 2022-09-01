# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }

  context 'when valid' do
    it { expect(user).to be_valid }
  end

  context 'when email is empty' do
    before { user.email = '' }

    it { expect(user).not_to be_valid }
  end

  context 'when email is nil' do
    before { user.email = nil }

    it { expect(user).not_to be_valid }
  end

  context 'when invalid email' do
    before { user.email = 'test' }

    it { expect(user).not_to be_valid }
  end

  context 'when password is empty' do
    before { user.password = '' }

    it { expect(user).not_to be_valid }
  end

  context 'when invalid password' do
    before { user.password = 'test' }

    it { expect(user).not_to be_valid }
  end

  context 'when email is taken' do
    before { user.email = 'nazar@gmail.com' }

    it { expect(user).not_to be_valid }
  end
end
