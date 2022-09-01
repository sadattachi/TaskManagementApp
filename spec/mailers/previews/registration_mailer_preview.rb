# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/registration_mailer
class RegistrationMailerPreview < ActionMailer::Preview
  def welcome_email
    RegistrationMailer.with(user: User.first).welcome_email
  end
end
