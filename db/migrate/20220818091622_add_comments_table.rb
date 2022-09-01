# frozen_string_literal: true

# Add comments table to DB
class AddCommentsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :worker_id
      t.integer :ticket_id
      t.string :message
      t.integer :reply_to_comment_id
      t.timestamps
    end
  end
end
