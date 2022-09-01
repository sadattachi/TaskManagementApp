# frozen_string_literal: true

# Notifies workers about mentions in comments
class CommentsMailer < ApplicationMailer
  def new_mention
    @mentioned_worker = params[:mentioned]
    @comment = params[:comment]
    mail(to: @mentioned_worker.user.email, subject: 'New mention!')
  end
end
