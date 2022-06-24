# json.extract! worker, :id, :last_name, :first_name, :age, :role
# json.set! :id, worker.id
json.set! :name, worker.first_name + ' ' + worker.last_name
json.set! :age, worker.age
json.set! :role, worker.role

# json.tickets worker.tickets do |ticket|
#   json.set! :title, ticket.title
#   json.set! :description, ticket.description
# end
