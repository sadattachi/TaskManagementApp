# frozen_string_literal: true

class AddCreatorWorkerIdToTicketsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :creator_worker_id, :integer
  end
end
