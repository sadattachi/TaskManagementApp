class CommentsController < ApplicationController
  before_action :auth_user, only: %i[create update destroy]
  before_action :set_comment, only: %i[show update destroy]
  def index
    @comments = Comment.where(ticket_id: params[:ticket_id].to_i).order(:created_at)
  end

  def show; end

  def create
    @comment = Comment.new(worker_id: params[:comment][:worker_id],
                           ticket_id: params[:ticket_id],
                           message: params[:comment][:message],
                           reply_to_comment_id: params[:comment][:reply_to_comment_id])

    if @comment.save
      email_for_mentions
      @comment.ticket.update(comments_count: @comment.ticket.comments_count + 1)
      render :show, status: :created, location: @ticket_comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if (Time.zone.now - @comment.created_at) / 3600 < 6
      if @comment.worker_id == current_user.id
        if @comment.update(message: params[:comment][:message])
          render :show, status: :ok, location: @ticket_comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      else
        forbidden_message('Only author can edit this comment!')
      end
    else
      render json: { error: 'Messages can only be edited for the first 6 hours!' }
    end
  end

  def destroy
    if (Time.zone.now - @comment.created_at) / 3600 < 1
      if @comment.worker_id == current_user.id
        if @comment.destroy
          @comment.ticket.update(comments_count: @comment.ticket.comments_count - 1)
          render json: { message: 'Comment was deleted' }, status: :ok
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      else
        forbidden_message('Only author can delete this comment!')
      end
    else
      render json: { error: 'Messages can only be deleted for the first hour!' }
    end
  end

  private

  def set_comment
    @comment = Comment.where(ticket_id: params[:ticket_id].to_i).find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def email_for_mentions
    name = @comment.message.match(/@[a-zA-Z]+_[a-zA-Z]+/)
  end
end
