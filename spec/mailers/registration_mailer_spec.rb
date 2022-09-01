# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationMailer, type: :mailer do
  describe 'welcome' do
    let(:mail) { described_class.with(user: User.first).welcome_email }

    it { expect(mail.subject).to eq('Welcome to Task Management App!') }
    it { expect(mail.to).to eq(['nazar@gmail.com']) }
    it { expect(mail.from).to eq(['test@example.com']) }

    it {  expect(mail.body.encoded).to match('Welcome, Nazar Tester') }
    it {  expect(mail.body.encoded).to match('Best of luck!') }
  end
end
