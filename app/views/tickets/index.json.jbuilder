# json.array! @workers do |worker|
#   json.partial! 'workers/worker', worker: worker
#   json.set! :tickets_count, worker.tickets.count
# end
# json.partial! 'tickets/ticket', ticket: @ticket

json.array! @tickets, partial: 'tickets/ticket', as: :ticket
