# frozen_string_literal: true

# Manages CRUD action for tickets
class TicketsController < ApplicationController
  before_action :auth_user
  before_action :check_deactivated
  before_action :check_admin_or_manager_permission!, only: :destroy
  before_action :set_ticket, only: %i[show update destroy ticket_from_backlog change_worker]
  before_action :set_new_ticket, only: %i[create]
  before_action :set_default_format, only: %i[index show]

  def index
    @tickets = Ticket.all
    filter_state
    filter_worker
    filter_date
  end

  def show; end

  def create
    if @ticket.worker.active
      save_ticket
    else
      render json: { error: "Worker can't be unactive!" }, status: :conflict
    end
  rescue StandardError
    render json: { error: "Worker doesn't exit!" }, status: :not_found
  end

  def update
    return unless @ticket.creator_worker == current_user.worker || check_admin_or_manager_permission!

    if @ticket.update(ticket_update_params)
      email_on_ticket_update
      render :show, status: :ok, location: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @ticket.destroy
      success_message('Ticket was deleted!')
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  # def change_state
  #   return unless @ticket.worker == current_user.worker || check_admin_or_manager_permission!

  #   if @ticket.update(params.require(:ticket).permit(:state))
  #     render :show, status: :ok, location: @ticket
  #   else
  #     render json: @ticket.errors, status: :unprocessable_entity
  #   end
  # end

  def ticket_from_backlog
    unless current_user.developer?
      error_message('Only developers can change state to Pending')
      return
    end
    @ticket.get_from_backlog!
    render :show, status: :ok, location: @ticket
  end

  def change_worker
    return unless @ticket.creator_worker == current_user.worker || check_admin_or_manager_permission!

    worker = Worker.find(params['ticket']['worker_id'].to_i)
    if worker.active
      change_worker_and_respond
    else
      render json: { error: "Worker can't be unactive!" }, status: :conflict
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def filter_state
    return if params[:state].blank?

    @tickets = @tickets.where('LOWER(state) LIKE :state', state: "%#{params[:state].downcase}%")
  end

  def filter_worker
    @tickets = @tickets.where('worker_id = :id', id: params[:worker]) if params[:worker].present?
  end

  def filter_date
    return if params[:start_date].blank? && params[:end_date].blank?

    @tickets = @tickets.where('TO_CHAR(created_at, \'dd.mm.yyyy\') BETWEEN :start AND :end',
                              start: params[:start_date], end: params[:end_date])
  end

  def email_on_ticket_update
    return if @ticket.previous_changes.nil?

    TaskMailer.with(user: @ticket.worker.user, changes: @ticket.previous_changes, ticket: @ticket,
                    updater: current_user).task_changed_email.deliver_later
  end

  def save_ticket
    if @ticket.save
      render :show, status: :created, location: @ticket
      # TaskMailer.with(user: User.find(params[:ticket][:worker_id]), ticket: @ticket).new_task_email.deliver_later
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def set_new_ticket
    @ticket = Ticket.new(title: params[:ticket][:title],
                         description: params[:ticket][:description],
                         worker_id: params[:ticket][:worker_id],
                         state: params[:ticket][:state],
                         creator_worker_id: current_user.worker.id)
  end

  def change_worker_and_respond
    result = change_worker_based_on_user
    if result
      TaskMailer.with(user: User.find(params[:ticket][:worker_id]), ticket: @ticket).new_task_email.deliver_later
      render :show, status: :ok, location: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def change_worker_based_on_user
    if current_user.manager?
      @ticket.update(params.require(:ticket).permit(:worker_id))
    else
      @ticket.update(worker_id: current_user.worker.id)
    end
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :worker_id, :state)
  end

  def ticket_update_params
    params.require(:ticket).permit(:title, :description)
  end

  def set_default_format
    request.format = 'json'
  end
end
