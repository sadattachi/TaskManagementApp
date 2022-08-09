require 'rails_helper'

RSpec.describe RegistrationMailer, type: :mailer do
  describe 'welcome' do
    let(:mail) { RegistrationMailer.with(user: User.first).welcome_email }

    it 'renders the headers' do
      puts mail.body.encoded
      expect(mail.subject).to eq('Welcome to Task Management App!')
      expect(mail.to).to eq(['nazar@gmail.com'])
      expect(mail.from).to eq(['test@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Welcome, Nazar Tester')
      expect(mail.body.encoded).to match('Best of luck!')
    end
  end
end
