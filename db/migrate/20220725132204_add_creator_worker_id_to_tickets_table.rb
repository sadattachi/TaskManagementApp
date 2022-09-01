# frozen_string_literal: true

# Add 'creator_worker_id' column to tickets table to track ticket's creator
class AddCreatorWorkerIdToTicketsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :creator_worker_id, :integer
  end
end
