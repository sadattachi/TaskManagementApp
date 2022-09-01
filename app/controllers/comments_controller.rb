# frozen_string_literal: true

# Controller for tickets' comments
class CommentsController < ApplicationController
  before_action :auth_user, only: %i[create update destroy]
  before_action :set_comment, only: %i[show update destroy]
  before_action :set_new_comment, only: %i[create]
  def index
    @comments = Comment.where(ticket_id: params[:ticket_id].to_i).order(:created_at)
  end

  def show; end

  def create
    if @comment.save
      email_for_mentions
      @comment.ticket.update(comments_count: @comment.ticket.comments_count + 1)
      render :show, status: :created, location: @ticket_comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if (Time.zone.now - @comment.created_at) / 3600 >= 6
      render json: { error: 'Messages can only be edited for the first 6 hours!' }, status: :forbidden
      return
    end
    if @comment.worker_id == current_user.id
      update_comment
    else
      forbidden_message('Only author can edit this comment!')
    end
  end

  def destroy
    if (Time.zone.now - @comment.created_at) / 3600 >= 1
      render json: { error: 'Messages can only be deleted for the first hour!' }, status: :forbidden
      return
    end
    if @comment.worker_id == current_user.id
      destroy_ticket
    else
      forbidden_message('Only author can delete this comment!')
    end
  end

  private

  def destroy_ticket
    if @comment.destroy
      @comment.ticket.update(comments_count: @comment.ticket.comments_count - 1)
      render json: { message: 'Comment was deleted' }, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update_comment
    if @comment.update(message: params[:comment][:message])
      render :show, status: :ok, location: @ticket_comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def set_new_comment
    @comment = Comment.new(worker_id: params[:comment][:worker_id],
                           ticket_id: params[:ticket_id],
                           message: params[:comment][:message],
                           reply_to_comment_id: params[:comment][:reply_to_comment_id])
  end

  def set_comment
    @comment = Comment.where(ticket_id: params[:ticket_id].to_i).find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def email_for_mentions
    @name = @comment.message.match(/@[a-zA-Z]+_[a-zA-Z]+/)
    return if @name.nil?

    split_name

    return unless !@user.nil? && @user.id != @comment.ticket.worker_id && @user.id != @comment.ticket.creator_worker_id

    CommentsMailer.with(mentioned: @user,
                        comment: @comment).new_mention.deliver_later
  end

  def split_name
    @full_name = @name[0].split('_')
    @first_name = @full_name[0][1..]
    @last_name = @full_name[1]
    @user = Worker.where('lower(first_name) = ? AND lower(last_name) = ?', @first_name.downcase,
                         @last_name.downcase).first
  end
end
