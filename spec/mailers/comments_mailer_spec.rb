# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsMailer, type: :mailer do
  describe '#new_mention' do
    let(:mail) do
      described_class.with(mentioned: Worker.last,
                           comment: Comment.first).new_mention
    end

    it { expect(mail.subject).to eq('New mention!') }
    it { expect(mail.to).to eq(['ben@gmail.com']) }
    it { expect(mail.from).to eq(['test@example.com']) }

    it { expect(mail.body.encoded).to match('You have been mentioned in comment!') }
    it { expect(mail.body.encoded).to match('Comment: "Hiiii!"') }
    it { expect(mail.body.encoded).to match('Mentioned by: Nazar Tester') }
  end
end
