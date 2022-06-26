class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show update destroy change_state change_worker]
  def index
    @tickets = Ticket.all
  end

  def show; end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.worker.active
      if @ticket.save
        render :show, status: :created, location: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Worker can\'t be unactive!" }, status: :conflict
    end
  rescue StandardError
    render json: { error: "Worker doesn't exit!" }, status: :bad_request
  end

  def update
    if @ticket.update(ticket_update_params)
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

  def change_state
    if @ticket.update(params.require(:ticket).permit(:state))
      render :show, status: :ok, location: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def change_worker
    if @ticket.update(params.require(:ticket).permit(:worker_id))
      render :show, status: :ok, location: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
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
    render json: { error: e.message }, status: :bad_request
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :worker_id, :state)
  end

  def ticket_update_params
    params.require(:ticket).permit(:title, :description)
  end
end
