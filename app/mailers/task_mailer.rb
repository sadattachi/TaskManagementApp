class TaskMailer < ApplicationMailer
  def new_task_email
    @user = params[:user]
    @ticket = params[:ticket]
    mail(to: @user.email, subject: 'New task assigned!')
  end

  def task_changed_email
    @user = params[:user]
    @title = params[:title]
    @description = params[:description]
    @new_ticket = params[:new_ticket]
    @updater = params[:updater]
    mail(to: @user.email, subject: 'Task changed!')
  end
end
