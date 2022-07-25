class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable, :validatable,
         jwt_revocation_strategy: JwtDenylist

  belongs_to :worker

  def developer?
    worker.role == 'Developer'
  end

  def manager?
    worker.role == 'Manager'
  end

  def designer?
    worker.role == 'UI/UX Designer'
  end
end
