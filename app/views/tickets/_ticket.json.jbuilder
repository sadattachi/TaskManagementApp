# frozen_string_literal: true

json.set! :title, ticket.title
json.set! :description, ticket.description
json.set! :worker_name, "#{ticket.worker.first_name} #{ticket.worker.last_name}"
json.set! :state, ticket.state
json.set! :created_at, ticket.created_at.strftime('%d-%m-%Y')
json.set! :creator, "#{ticket.creator_worker.first_name} #{ticket.creator_worker.last_name}"
