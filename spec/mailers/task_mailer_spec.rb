# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe 'new task' do
    let(:mail) do
      described_class.with(user: User.first, ticket: Ticket.first).new_task_email
    end

    it { expect(mail.subject).to eq('New task assigned!') }
    it { expect(mail.to).to eq(['nazar@gmail.com']) }
    it { expect(mail.from).to eq(['test@example.com']) }

    it { expect(mail.body.encoded).to match('New task!') }
    it { expect(mail.body.encoded).to match('Title: test') }
    it { expect(mail.body.encoded).to match('Description: test') }

    it 'includes link to a new ticket' do
      expect(mail.body.encoded).to match('http://127.0.0.1:3000/tickets/1')
    end
  end

  describe 'task changed' do
    let(:mail) do
      ticket = Ticket.first
      ticket.title = 'Change title'
      ticket.description = 'New desc'
      described_class.with(user: User.first, changes: ticket.changes, ticket: ticket,
                           updater: User.last).task_changed_email
    end

    it { expect(mail.subject).to eq('Task changed!') }
    it { expect(mail.to).to eq(['nazar@gmail.com']) }
    it { expect(mail.from).to eq(['test@example.com']) }

    it { expect(mail.body.encoded).to match('Task changed!') }
    it { expect(mail.body.encoded).to match('Title: Change title') }
    it { expect(mail.body.encoded).to match('Title: test') }

    it 'includes updater' do
      expect(mail.body.encoded).to match('Ben Fired')
    end

    it 'includes link to ticket' do
      expect(mail.body.encoded).to match('http://127.0.0.1:3000/tickets/1')
    end
  end
end
