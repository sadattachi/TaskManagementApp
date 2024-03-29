# frozen_string_literal: true

# Notifies workers about new tasks or changes in existing tasks
class TaskMailer < ApplicationMailer
  def new_task_email
    @user = params[:user]
    @ticket = params[:ticket]
    mail(to: @user.email, subject: 'New task assigned!')
  end

  def task_changed_email
    @user = params[:user]
    @changes = params[:changes]
    @ticket = params[:ticket]
    @updater = params[:updater]
    mail(to: @user.email, subject: 'Task changed!')
  end
end
