class WorkersController < ApplicationController
  before_action :set_worker, only: %i[show destroy]
  # before_action :set_worker, only: %i[show edit update destroy]
  def index
    @workers = Worker.all
  end

  def show; end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      render :show, status: :created, location: @worker
    else
      render json: @worker.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @worker.tickets.count > 0
      payload = {
        error: "Can't delete worker with tickets!",
        status: 409
      }
      render json: payload, status: :conflict
    else
      @worker.destroy
      payload = {
        message: 'Worker was deleted!',
        status: 200
      }
      render json: payload, status: :ok
    end
  end

  private

  def set_worker
    @worker = Worker.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :age, :role)
  end
end
