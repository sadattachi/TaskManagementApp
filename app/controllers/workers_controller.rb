class WorkersController < ApplicationController
  before_action :set_worker, only: %i[show update destroy activate]
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

  def update
    if @worker.update(worker_update_params)
      render :show, status: :ok, location: @worker
    else
      render json: @worker.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @worker.tickets.count > 0
      deletion_error
    else
      @worker.destroy
      success_message('Worker was deleted!')
    end
  end

  def activate
    @worker.update(active: true)
    success_message('Worker is now active!')
  end

  private

  def deletion_error
    payload = {
      error: "Can't delete worker with tickets!",
      status: 409
    }
    render json: payload, status: :conflict
  end

  def success_message(str)
    payload = {
      message: str,
      status: 200
    }
    render json: payload, status: :ok
  end

  def set_worker
    @worker = Worker.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :age, :role, :active)
  end

  def worker_update_params
    params.require(:worker).permit(:last_name, :first_name, :age, :role)
  end
end
