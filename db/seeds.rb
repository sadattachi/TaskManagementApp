# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

workers = Worker.create([{ last_name: 'Tester', first_name: 'Nazar', age: 18, role: 'Developer', active: true },
                         { last_name: 'Lazy', first_name: 'Ivan', age: 20, role: 'Manager', active: true },
                         { last_name: 'Fast', first_name: 'John', age: 18, role: 'UI/UX Designer', active: true },
                         { last_name: 'Fired', first_name: 'Ben', age: 18, role: 'Developer', active: true }])

Ticket.create([{ title: 'test', description: 'test', worker: workers[0], state: 'Pending' },
               { title: 'more', description: 'test', worker: workers[1], state: 'In progress' },
               { title: 'some', description: 'test', worker: workers[2], state: 'Done' }])
