# frozen_string_literal: true

# Add 'comments_count' column to tickets
class AddCommentsCountToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :comments_count, :integer
  end
end
