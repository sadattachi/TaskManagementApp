json.partial! 'workers/worker', worker: @worker

json.tickets @worker.tickets do |ticket|
  json.set! :title, ticket.title
  json.set! :description, ticket.description
end
