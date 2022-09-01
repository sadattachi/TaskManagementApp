# frozen_string_literal: true

# Controller for admin user
class AdminsController < ApplicationController
  before_action :auth_user
  before_action :check_deactivated
  before_action :check_admin_permission!
  before_action :set_user

  def assign_admin
    if @user.manager?
      @user.update(is_admin: true)
      render json: { message: 'User is now admin' }, status: :ok
    else
      render json: { message: 'Only manager can be an admin' }, status: :conflict
    end
  end

  def unassign_admin
    @user.update(is_admin: false)
    render json: { message: 'User is no longer admin' }, status: :ok
  end

  private

  def set_user
    @user = User.select { |u| u.worker.id == params[:id].to_i }.first

    render json: { error: 'User does not exist' }, status: :not_found if @user.nil?
  end
end
