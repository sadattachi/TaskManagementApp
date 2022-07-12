require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(email: 'test@email.com',
             password: 'test pass')
  end
  it 'is valid' do
    expect(user).to be_valid
  end
  it 'is not valid without email' do
    user.email = ''
    expect(user).to_not be_valid
  end
  it 'is not valid without password' do
    user.password = ''
    expect(user).to_not be_valid
  end
  it 'is not valid with invalid email' do
    user.email = 'test'
    expect(user).to_not be_valid
  end
  it 'is not valid with invalid password' do
    user.password = 'test'
    expect(user).to_not be_valid
  end
end
