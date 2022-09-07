class StateChangeMailer < ApplicationMailer
  def notify_worker
    @ticket = params[:ticket]
    mail(to: @ticket.worker.user.email, subject: 'Ticket state changed')
  end
end
