# frozen_string_literal: true

# Manages CRUD actions for workers
class WorkersController < ApplicationController
  before_action :auth_user
  before_action :check_deactivated
  before_action :check_admin_permission!, only: :destroy
  before_action :check_admin_or_manager_permission!, only: %i[activate deactivate]
  before_action :set_worker, only: %i[show update destroy activate deactivate]
  before_action :set_default_format, only: %i[index show]

  def index
    @workers = Worker.all
  end

  def show; end

  def update
    return unless @worker == current_user.worker || check_admin_or_manager_permission!

    result = update_worker
    if result
      render :show, status: :ok, location: @worker
    else
      render json: @worker.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @worker.tickets.count.positive?
      error_message("Can't delete worker with tickets!")
    elsif @worker.destroy
      success_message('Worker was deleted!')
    else
      render json: @worker.errors, status: :unprocessable_entity
    end
  end

  def activate
    @worker.update(active: true)
    success_message('Worker is now active!')
  end

  def deactivate
    if @worker.user.admin?
      error_message("Can't deactivate admin")
    elsif @worker.tickets.any? { |t| t.state.in? %w[pending in_progress] }
      error_message("Can't deactivate worker with 'pending' or 'in_progress' tickets!")
    else
      @worker.update(active: false)
      success_message('Worker is now inactive!')
    end
  end

  private

  def update_worker
    if current_user.manager?
      @worker.update(manager_worker_update_params)
    else
      @worker.update(worker_update_params)
    end
  end

  def set_worker
    @worker = Worker.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :age, :role, :active)
  end

  def manager_worker_update_params
    params.require(:worker).permit(:last_name, :first_name, :age, :role)
  end

  def worker_update_params
    params.require(:worker).permit(:last_name, :first_name, :age)
  end

  def set_default_format
    request.format = 'json'
  end
end
