# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Worker, type: :model do
  let(:worker) { FactoryBot.create :worker }

  context 'when valid attributes' do
    it { expect(worker).to be_valid }
  end

  context 'when last_name is longer than 20 characters' do
    before { worker.last_name = 'way too long last name for worker' }

    it { expect(worker).not_to be_valid }
  end

  context 'when first_name is longer than 20 characters' do
    before { worker.first_name = 'way too long first name for worker' }

    it { expect(worker).not_to be_valid }
  end

  context 'when age is below 16' do
    before { worker.age = 10 }

    it { expect(worker).not_to be_valid }
  end

  context 'when age is above 60' do
    before { worker.age = 70 }

    it { expect(worker).not_to be_valid }
  end

  context 'when role is not valid' do
    before { worker.role = 'test' }

    it { expect(worker).not_to be_valid }
  end
end
