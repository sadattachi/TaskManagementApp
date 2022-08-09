require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe 'new task' do
    let(:mail) do
      TaskMailer.with(user: User.first, ticket: Ticket.first).new_task_email
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('New task assigned!')
      expect(mail.to).to eq(['nazar@gmail.com'])
      expect(mail.from).to eq(['test@example.com'])
    end

    it 'informs user about ticket' do
      expect(mail.body.encoded).to match('New task!')
      expect(mail.body.encoded).to match('Title: test')
      expect(mail.body.encoded).to match('Description: test')
    end

    it 'includes link to a new ticket' do
      expect(mail.body.encoded).to match('http://127.0.0.1:3000/tickets/1')
    end
  end
  describe 'task changed' do
    let(:mail) do
      @ticket = Ticket.first
      @title = 'Change title'
      @description = 'New desc'

      TaskMailer.with(user: User.first, title: @title, description: @description, new_ticket: @ticket,
                      updater: User.last).task_changed_email
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Task changed!')
      expect(mail.to).to eq(['nazar@gmail.com'])
      expect(mail.from).to eq(['test@example.com'])
    end

    it 'informs user about changes' do
      expect(mail.body.encoded).to match('Task changed!')
      expect(mail.body.encoded).to match('Title: Change title')
      expect(mail.body.encoded).to match('Title: test')
    end
    it 'includes updater' do
      expect(mail.body.encoded).to match('Ben Fired')
    end
    it 'includes link to ticket' do
      expect(mail.body.encoded).to match('http://127.0.0.1:3000/tickets/1')
    end
  end
end
