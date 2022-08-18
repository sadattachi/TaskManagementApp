class AddDefaultValueToCommentsCount < ActiveRecord::Migration[6.1]
  def up
    change_column_default :tickets, :comments_count, 0
  end

  def down
    change_column_default :tickets, :comments_count, nil
  end
end
