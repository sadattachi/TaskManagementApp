# frozen_string_literal: true

if Rails.env.test?
  workers = Worker.create([{ last_name: 'Tester', first_name: 'Nazar', age: 18, role: 'Manager', active: true },
                           { last_name: 'Lazy', first_name: 'Ivan', age: 20, role: 'Developer', active: true },
                           { last_name: 'Serious', first_name: 'Ted', age: 25, role: 'Manager', active: true },
                           { last_name: 'Fast', first_name: 'John', age: 18, role: 'UI/UX Designer', active: true },
                           { last_name: 'Fired', first_name: 'Ben', age: 18, role: 'Developer', active: false }])

  Ticket.create([{ title: 'test', description: 'test', worker: workers[0], state: 'backlog',
                   creator_worker: workers[1] },
                 { title: 'more', description: 'test', worker: workers[1], state: 'in_progress',
                   creator_worker: workers[2] },
                 { title: 'some', description: 'test', worker: workers[2], state: 'done',
                   creator_worker: workers[1] },
                 { title: 'test', description: 'ticket', worker: workers[1], state: 'waiting_for_accept',
                   creator_worker: workers[1] },
                 { title: 'test', description: 'finish', worker: workers[1], state: 'accepted',
                   creator_worker: workers[1] },
                 { title: 'test', description: 'pending', worker: workers[1], state: 'pending',
                   creator_worker: workers[1] },
                 { title: 'test', description: 'declined', worker: workers[2], state: 'declined',
                   creator_worker: workers[1] }])

  User.create({ email: 'nazar@gmail.com', password: 'test pass', worker: workers[0], is_admin: true })
  User.create({ email: 'ivan@gmail.com', password: 'test pass', worker: workers[1], is_admin: false })
  User.create({ email: 'ted@gmail.com', password: 'test pass', worker: workers[2], is_admin: false })
  User.create({ email: 'john@gmail.com', password: 'test pass', worker: workers[3], is_admin: false })
  User.create({ email: 'ben@gmail.com', password: 'test pass', worker: workers[4], is_admin: false })

  Comment.create({ worker_id: 1, ticket_id: 1, message: 'Hiiii!', reply_to_comment_id: nil })
  Comment.create({ worker_id: 2, ticket_id: 1, message: 'Hi!', reply_to_comment_id: 1 })
  Comment.create({ worker_id: 3, ticket_id: 1, message: 'Hello!', reply_to_comment_id: 2 })
end
