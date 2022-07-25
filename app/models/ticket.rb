class Ticket < ApplicationRecord
  belongs_to :worker
  belongs_to :creator_worker, class_name: 'Worker'

  validates :title, length: { maximum: 40 }
  validates :worker_id, presence: true
  validates :state, inclusion: { in: ['Pending', 'In progress', 'Done'],
                                 message: '%{value} is not a valid state' }
end
