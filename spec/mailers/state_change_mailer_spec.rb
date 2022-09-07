# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StateChangeMailer, type: :mailer do
  describe 'notify_worker' do
    let(:mail) do
      described_class.with(ticket: Ticket.last).notify_worker
    end

    it { expect(mail.subject).to eq('Ticket state changed') }
    it { expect(mail.to).to eq(['ted@gmail.com']) }
    it { expect(mail.from).to eq(['test@example.com']) }

    it { expect(mail.body.encoded).to match('Ticket "test" state changed to: declined') }
  end

  describe 'notify_manager' do
    let(:mail) do
      described_class.with(ticket: Ticket.last).notify_manager
    end

    it { expect(mail.subject).to eq('Ticket state changed') }
    it { expect(mail.to).to eq(['ivan@gmail.com']) }
    it { expect(mail.from).to eq(['test@example.com']) }

    it { expect(mail.body.encoded).to match('Ticket "test" is declined') }
  end
end
