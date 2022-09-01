# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview
  def new_task_email
    @user = User.new(email: 'test@example.com', password: 'password')
    @ticket = Ticket.new(title: 'preview', description: 'preview', state: 'Done', worker_id: 1)

    TaskMailer.with(user: @user, ticket: @ticket).new_task_email
  end

  def task_changed_email
    @ticket = Ticket.first
    @ticket.title = 'New title'
    @ticket.description = 'New Desc'
    TaskMailer.with(user: User.first, changes: @ticket.changes, ticket: @ticket,
                    updater: User.last).task_changed_email
  end
end
