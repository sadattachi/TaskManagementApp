# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'test@example.com'
  layout 'mailer'
end
