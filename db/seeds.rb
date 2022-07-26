# frozen_string_literal: true

if Rails.env.test?
  workers = Worker.create([{ last_name: 'Tester', first_name: 'Nazar', age: 18, role: 'Developer', active: true },
                           { last_name: 'Lazy', first_name: 'Ivan', age: 20, role: 'Manager', active: true },
                           { last_name: 'Fast', first_name: 'John', age: 18, role: 'UI/UX Designer', active: true },
                           { last_name: 'Fired', first_name: 'Ben', age: 18, role: 'Developer', active: false }])

  Ticket.create([{ title: 'test', description: 'test', worker: workers[0], state: 'Pending' },
                 { title: 'more', description: 'test', worker: workers[1], state: 'In progress' },
                 { title: 'some', description: 'test', worker: workers[2], state: 'Done' }])

  User.create({ email: 'test@gmail.com', password: 'test pass' })
end
