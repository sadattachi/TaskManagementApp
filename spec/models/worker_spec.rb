require 'rails_helper'

RSpec.describe Worker, type: :model do
  let(:worker) do
    Worker.new(last_name: 'test',
               first_name: 'test',
               age: 40,
               role: 'Developer')
  end

  it 'is valid with valid attributes' do
    expect(worker).to be_valid
  end

  it 'is not valid with last_name longer than 20 characters' do
    worker.last_name = 'way too long last name for worker'
    expect(worker).to_not be_valid
  end

  it 'is not valid with first_name longer than 20 characters' do
    worker.first_name = 'way too long first name for worker'
    expect(worker).to_not be_valid
  end

  it 'is not valid with age below 16' do
    worker.age = 10
    expect(worker).to_not be_valid
  end

  it 'is not valid with age above 60' do
    worker.age = 70
    expect(worker).to_not be_valid
  end

  it 'is not valid if role is not Developer, Manager or UI/UX Designer' do
    worker.role = 'test'
    expect(worker).to_not be_valid
  end
end
