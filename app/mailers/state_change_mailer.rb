# frozen_string_literal: true

# Mailer to notify users about ticket state change
class StateChangeMailer < ApplicationMailer
  def notify_worker
    @ticket = params[:ticket]
    mail(to: @ticket.worker.user.email, subject: 'Ticket state changed')
  end

  def notify_manager
    @ticket = params[:ticket]
    mail(to: @ticket.creator_worker.user.email, subject: 'Ticket state changed')
  end
end
