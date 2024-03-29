# frozen_string_literal: true

# Welcomes new workers
class RegistrationMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]

    mail(to: @user.email, subject: 'Welcome to Task Management App!')
  end
end
