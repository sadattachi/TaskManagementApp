# frozen_string_literal: true

# Add 'is_admin' column to user
class AddIsAdminToUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_admin, :boolean
  end
end
