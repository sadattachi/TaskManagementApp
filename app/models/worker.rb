# frozen_string_literal: true

class Worker < ApplicationRecord
  has_many :tickets
  has_many :created_tickets, foreign_key: :creator_worker_id, class_name: 'Ticket'

  validates :last_name, length: { maximum: 20 }
  validates :first_name, length: { maximum: 20 }
  validates :age, inclusion: 16..60
  validates :role, inclusion: { in: ['Manager', 'Developer', 'UI/UX Designer'],
                                message: '%{value} is not a valid role' }

  has_one :user
end
