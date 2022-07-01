require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) do
    Ticket.new(title: 'test title',
               description: 'test',
               worker_id: 1,
               state: 'Done')
  end

  it 'is valid with valid attributes' do
    expect(ticket).to be_valid
  end

  it 'is not valid with title longer than 40 characters' do
    ticket.title = 'title that is definitely longer than 40 characters'
    expect(ticket).to_not be_valid
  end

  it 'is not valid if worker_id is nil' do
    ticket.worker_id = nil
    expect(ticket).to_not be_valid
  end

  it 'is not valid if worker_id is not in database' do
    ticket.worker_id = 10
    expect(ticket).to_not be_valid
  end

  it 'is not valid if state is not Pending, In progress or Done' do
    ticket.state = 'test'
    expect(ticket).to_not be_valid
  end
end
