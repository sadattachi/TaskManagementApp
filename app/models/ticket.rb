# frozen_string_literal: true

class Ticket < ApplicationRecord
  include ActiveModel::Dirty
  include RailsStateMachine::Model
  # define_attribute_methods :title, :description

  belongs_to :worker
  belongs_to :creator_worker, class_name: 'Worker'

  has_many :comments, dependent: nil

  validates :title, length: { maximum: 40 }
  validates :worker_id, presence: true

  state_machine do
    state :backlog, initial: true
    state :pending
    state :in_progress
    state :waiting_for_accept
    state :accepted
    state :declined
    state :done

    event :get_from_backlog do
      transitions from: :backlog, to: :pending
    end

    event :start_working do
      transitions from: %i[pending declined], to: :in_progress
    end

    event :review do
      transitions from: :in_progress, to: :waiting_for_accept
    end

    event :accept do
      transitions from: :waiting_for_accept, to: :accepted
    end

    event :decline do
      transitions from: :waiting_for_accept, to: :declined
    end

    event :finish do
      transitions from: :accepted, to: :done
    end
  end
end
