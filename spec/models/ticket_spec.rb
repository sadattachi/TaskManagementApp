# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) do
    FactoryBot.create :ticket
  end
  context 'when valid attributes' do
    it { expect(ticket).to be_valid }
  end

  context 'when title is longer than 40 characters' do
    before { ticket.title = 'title that is definitely longer than 40 characters' }
    it { expect(ticket).to_not be_valid }
  end

  context 'when worker_id is nil' do
    before { ticket.worker_id = nil }
    it { expect(ticket).to_not be_valid }
  end

  context 'when worker_id is not in db' do
    before { ticket.worker_id = 10 }
    it { expect(ticket).to_not be_valid }
  end
  context 'when state is not valid' do
    before { ticket.state = 'test' }
    it { expect(ticket).to_not be_valid }
  end
end
