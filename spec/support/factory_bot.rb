FactoryBot.define do
  factory :ticket do
    title { 'test title' }
    description { 'test' }
    worker_id { 1 }
    state { 'Done' }
  end
  factory :worker do
    last_name { 'test' }
    first_name { 'test' }
    age { 40 }
    role { 'Developer' }
  end
end
