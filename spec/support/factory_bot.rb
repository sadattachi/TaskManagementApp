# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    title { 'test title' }
    description { 'test' }
    worker_id { 1 }
    state { 'done' }
    creator_worker_id { 1 }
  end

  factory :worker do
    last_name { 'test' }
    first_name { 'test' }
    age { 40 }
    role { 'Developer' }
  end

  factory :user do
    email { 'test@gmail.com' }
    password { 'test pass' }
    worker_id { 0 }
    is_admin { false }
  end
end
