# frozen_string_literal: true

# Add workers table
class CreateWorker < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      t.string :last_name
      t.string :first_name
      t.integer :age
      t.string :role
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
