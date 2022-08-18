class Comment < ApplicationRecord
  belongs_to :ticket

  belongs_to :reply_to, class_name: 'Comment', foreign_key: 'reply_to_comment_id', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'reply_to_comment_id'
end
