# frozen_string_literal: true

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

  factory :user do
    email { 'test@email.com' }
    password { 'test pass' }
  end
end
