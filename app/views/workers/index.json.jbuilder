# frozen_string_literal: true

json.array! @workers do |worker|
  json.partial! 'workers/worker', worker: worker
  json.set! :tickets_count, worker.tickets.count
end
