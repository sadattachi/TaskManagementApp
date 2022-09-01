# frozen_string_literal: true

class Worker < ApplicationRecord
  has_many :tickets, dependent: nil
  has_many :created_tickets, foreign_key: :creator_worker_id, class_name: 'Ticket',
                             dependent: nil, inverse_of: 'creator_worker'

  validates :last_name, length: { maximum: 20 }
  validates :first_name, length: { maximum: 20 }
  validates :age, inclusion: 16..60
  validates :role, inclusion: { in: ['Manager', 'Developer', 'UI/UX Designer'],
                                message: '%<value>s is not a valid role' }

  has_one :user, dependent: nil
end
