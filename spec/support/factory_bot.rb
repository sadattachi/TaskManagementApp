FactoryBot.define do
  factory :ticket do
    title { 'test title' }
    description { 'test' }
    worker_id { 1 }
    state { 'Done' }
  end
end
