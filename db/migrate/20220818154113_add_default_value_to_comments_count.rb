# frozen_string_literal: true

# Add default value of '0' to column 'comments_count' in tickets
class AddDefaultValueToCommentsCount < ActiveRecord::Migration[6.1]
  def up
    change_column_default :tickets, :comments_count, 0
  end

  def down
    change_column_default :tickets, :comments_count, nil
  end
end
