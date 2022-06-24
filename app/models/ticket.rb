class Ticket < ApplicationRecord
  belongs_to :worker

  validates :title, length: { maximum: 40 }
  validates :worker_id, presence: true
  validates :state, inclusion: { in: ['Pending', 'In progress', 'Done'],
                                 message: '%{value} is not a valid state' }
end
