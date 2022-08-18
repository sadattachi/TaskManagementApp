class CommentsController < ApplicationController
  def index
    @comments = Comment.where(ticket_id: params[:ticket_id].to_i)
  end
end
