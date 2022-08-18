# frozen_string_literal: true

json.set! :worker, "#{comment.ticket.worker.first_name} #{comment.ticket.worker.last_name}"
json.set! :ticket, comment.ticket.title
json.set! :message, comment.message
json.set! :reply_to, comment.reply_to
