# frozen_string_literal: true

class Ticket < ApplicationRecord
  include ActiveModel::Dirty
  # define_attribute_methods :title, :description

  belongs_to :worker
  belongs_to :creator_worker, class_name: 'Worker'

  has_many :comments

  validates :title, length: { maximum: 40 }
  validates :worker_id, presence: true
  validates :state, inclusion: { in: ['Pending', 'In progress', 'Done'],
                                 message: '%<value>s is not a valid state' }
end
