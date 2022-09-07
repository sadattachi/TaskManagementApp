# Preview all emails at http://localhost:3000/rails/mailers/state_change
class StateChangePreview < ActionMailer::Preview
  def notify_worker
    @ticket = Ticket.last
    StateChangeMailer.with(ticket: @ticket).notify_worker
  end
end
