class CreateTicket < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :worker_id
      t.string :state
      t.timestamps
    end
  end
end
