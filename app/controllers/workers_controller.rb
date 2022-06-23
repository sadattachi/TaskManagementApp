class WorkersController < ApplicationController
  before_action :set_worker, only: %i[show]
  # before_action :set_worker, only: %i[show edit update destroy]
  def index
    @workers = Worker.all
  end

  def show; end

  def create
    @worker = Worker.new(worker_params)
    respond_to do |format|
      if @worker.save
        format.json { render :show, status: :created, location: @worker }
      else
        format.json { render json: @worker.errors, status: :unprocessable_entity }
      end
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
