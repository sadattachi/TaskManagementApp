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

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :worker_id, :state)
  end
end
