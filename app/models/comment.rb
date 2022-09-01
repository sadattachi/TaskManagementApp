# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :worker

  belongs_to :reply_to, class_name: 'Comment', foreign_key: 'reply_to_comment_id', optional: true, inverse_of: 'replies'
  has_many :replies, class_name: 'Comment', foreign_key: 'reply_to_comment_id', dependent: nil, inverse_of: 'reply_to'
end
