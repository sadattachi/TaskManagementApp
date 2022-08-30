require 'rails_helper'

RSpec.describe CommentsMailer, type: :mailer do
  describe '#new_mention' do
    let(:mail) do
      CommentsMailer.with(mentioned: Worker.last,
                          comment: Comment.first).new_mention
    end
    it 'renders the headers' do
      expect(mail.subject).to eq('New mention!')
      expect(mail.to).to eq(['ben@gmail.com'])
      expect(mail.from).to eq(['test@example.com'])
    end
    it 'renders the body' do
      expect(mail.body.encoded).to match('You have been mentioned in comment!')
      expect(mail.body.encoded).to match('Comment: "Hiiii!"')
      expect(mail.body.encoded).to match('Mentioned by: Nazar Tester')
    end
  end
end
