class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :create_worker, only: :create
  after_action :add_worker_id, only: :create

  private

  def create_worker
    @worker = Worker.new(worker_params)
    render json: @worker.errors, status: :unprocessable_entity unless @worker.save
  end

  def add_worker_id
    if @user.persisted?
      @user.update(worker_id: @worker.id)
    else
      @worker.destroy
    end
  end

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    render json: { message: 'Signed up.' }
  end

  def register_failed
    render json: { message: @user.errors.full_messages }
  end

  def worker_params
    params.require(:worker).permit(:last_name, :first_name, :age, :role, :active)
  end
end
