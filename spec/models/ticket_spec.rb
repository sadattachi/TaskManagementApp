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

    it { expect(ticket).not_to be_valid }
  end

  context 'when worker_id is nil' do
    before { ticket.worker_id = nil }

    it { expect(ticket).not_to be_valid }
  end

  context 'when worker_id is not in db' do
    before { ticket.worker_id = 10 }

    it { expect(ticket).not_to be_valid }
  end

  context 'when getting ticket from backlog' do
    before do
      ticket.state = 'backlog'
      ticket.save
      ticket.get_from_backlog
    end

    it { expect(ticket.state).to eq('pending') }
  end

  context 'when starting_working' do
    before do
      ticket.state = 'pending'
      ticket.save
      ticket.start_working
    end

    it { expect(ticket.state).to eq('in_progress') }
  end

  context 'when moving to review' do
    before do
      ticket.state = 'in_progress'
      ticket.save
      ticket.review
    end

    it { expect(ticket.state).to eq('waiting_for_accept') }
  end

  context 'when accepting' do
    before do
      ticket.state = 'waiting_for_accept'
      ticket.save
      ticket.accept
    end

    it { expect(ticket.state).to eq('accepted') }
  end

  context 'when declining' do
    before do
      ticket.state = 'waiting_for_accept'
      ticket.save
      ticket.decline
    end

    it { expect(ticket.state).to eq('declined') }
  end

  context 'when continuing working' do
    before do
      ticket.state = 'declined'
      ticket.save
      ticket.continue_working
    end

    it { expect(ticket.state).to eq('in_progress') }
  end

  context 'when finishing' do
    before do
      ticket.state = 'accepted'
      ticket.save
      ticket.finish
    end

    it { expect(ticket.state).to eq('done') }
  end
end
