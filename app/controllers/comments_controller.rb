class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show update destroy]
  def index
    @comments = Comment.where(ticket_id: params[:ticket_id].to_i)
  end

  def show; end

  private

  def set_comment
    @comment = Comment.where(ticket_id: params[:ticket_id].to_i).find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
