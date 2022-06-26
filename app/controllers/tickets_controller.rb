class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show update destroy activate deactivate]
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

  private

  def success_message(str)
    payload = {
      message: str,
      status: 200
    }
    render json: payload, status: :ok
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :worker_id, :state)
  end

  def ticket_update_params
    params.require(:ticket).permit(:title, :description)
  end
end
