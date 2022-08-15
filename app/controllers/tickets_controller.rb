# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :auth_user
  before_action :check_deactivated
  before_action :check_admin_or_manager_permission!, only: :destroy
  before_action :set_ticket, only: %i[show update destroy change_state change_worker]
  before_action :set_default_format, only: %i[index show]

  def index
    @tickets = Ticket.all
    unless params[:state].blank?
      @tickets = @tickets.where('LOWER(state) LIKE :state', state: "%#{params[:state].downcase}%")
    end
    @tickets = @tickets.where('worker_id = :id', id: params[:worker]) unless params[:worker].blank?
    if !params[:start_date].blank? && !params[:end_date].blank?
      @tickets = @tickets.where('TO_CHAR(created_at, \'dd.mm.yyyy\') BETWEEN :start AND :end',
                                start: params[:start_date], end: params[:end_date])
    end
  end

  def show; end

  def create
    @ticket = Ticket.new(title: params[:ticket][:title],
                         description: params[:ticket][:description],
                         worker_id: params[:ticket][:worker_id],
                         state: params[:ticket][:state],
                         creator_worker_id: current_user.worker.id)
    if @ticket.worker.active
      if @ticket.save
        render :show, status: :created, location: @ticket
        TaskMailer.with(user: User.find(params[:ticket][:worker_id]), ticket: @ticket).new_task_email.deliver_later
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Worker can't be unactive!" }, status: :conflict
    end
  rescue StandardError
    render json: { error: "Worker doesn't exit!" }, status: :not_found
  end

  def update
    if @ticket.creator_worker == current_user.worker || check_admin_or_manager_permission!
      if @ticket.update(ticket_update_params)
        unless @ticket.previous_changes.nil?
          TaskMailer.with(user: @ticket.worker.user, changes: @ticket.previous_changes, ticket: @ticket,
                          updater: current_user).task_changed_email.deliver_later
        end
        render :show, status: :ok, location: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @ticket.destroy
      success_message('Ticket was deleted!')
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def change_state
    if @ticket.worker == current_user.worker || check_admin_or_manager_permission!
      if @ticket.update(params.require(:ticket).permit(:state))
        render :show, status: :ok, location: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    end
  end

  def change_worker
    if @ticket.creator_worker == current_user.worker || check_admin_or_manager_permission!
      worker = Worker.find(params['ticket']['worker_id'].to_i)
      if worker.active
        result = if current_user.manager?
                   @ticket.update(params.require(:ticket).permit(:worker_id))
                 else
                   @ticket.update(worker_id: current_user.worker.id)
                 end
        if result
          TaskMailer.with(user: User.find(params[:ticket][:worker_id]), ticket: @ticket).new_task_email.deliver_later
          render :show, status: :ok, location: @ticket
        else
          render json: @ticket.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Worker can't be unactive!" }, status: :conflict
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def success_message(message)
    payload = {
      message: message,
      status: 200
    }
    render json: payload, status: :ok
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
