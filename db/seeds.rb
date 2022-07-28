# frozen_string_literal: true

if Rails.env.test?
  workers = Worker.create([{ last_name: 'Tester', first_name: 'Nazar', age: 18, role: 'Manager', active: true },
                           { last_name: 'Lazy', first_name: 'Ivan', age: 20, role: 'Developer', active: true },
                           { last_name: 'Fast', first_name: 'John', age: 18, role: 'UI/UX Designer', active: true },
                           { last_name: 'Fired', first_name: 'Ben', age: 18, role: 'Developer', active: false }])

  Ticket.create([{ title: 'test', description: 'test', worker: workers[0], state: 'Pending', creator_worker: workers[1] },
                 { title: 'more', description: 'test', worker: workers[1], state: 'In progress',
                   creator_worker: workers[1] },
                 { title: 'some', description: 'test', worker: workers[2], state: 'Done', creator_worker: workers[1] }])

  User.create({ email: 'nazar@gmail.com', password: 'test pass', worker: workers[0], is_admin: true })
  User.create({ email: 'ivan@gmail.com', password: 'test pass', worker: workers[1], is_admin: false })
  User.create({ email: 'john@gmail.com', password: 'test pass', worker: workers[2], is_admin: false })
  User.create({ email: 'ben@gmail.com', password: 'test pass', worker: workers[3], is_admin: false })
end
