class TaskMailer < ApplicationMailer
  def new_task_email
    @user = params[:user]
    @ticket = params[:ticket]
    mail(to: @user.email, subject: 'New task assigned!')
  end
end
