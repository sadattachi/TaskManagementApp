# frozen_string_literal: true

# Add 'worker_id' to users
class AddWorkerIdToUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :worker_id, :integer
  end
end
