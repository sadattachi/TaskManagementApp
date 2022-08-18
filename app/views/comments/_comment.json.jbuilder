# frozen_string_literal: true

json.set! :worker, "#{comment.worker.first_name} #{comment.worker.last_name}"
json.set! :ticket, comment.ticket.title
json.set! :message, comment.message
json.set! :reply_to, comment.reply_to
